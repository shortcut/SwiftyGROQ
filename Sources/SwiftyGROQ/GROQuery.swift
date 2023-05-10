import Foundation

public final class GROQuery: NSObject {
    public static let defaultStyle: Style = .multiline
    
    let scope: Scope = .all
    let style: Style
    private let whereFields: QueryBuilderHandler?
    private let fields: () -> String?
    
    @objc
    var underlyingSlice: Any? = Slice.all
    var slice: Slice {
        (underlyingSlice as? Slice) ?? .all
    }
    
    @objc
    var underlyingOrder: Any? = [Order]()
    var order: [Order] {
        (underlyingOrder as? [Order]) ?? []
    }
    
    public typealias QueryBuilderHandler = () -> (any GROQWhereField, [any GROQueryRootField])
    
    public init(style: Style = GROQuery.defaultStyle, @GROQueryBuilder whereFields: @escaping QueryBuilderHandler, @GROQFieldBuilder fields: @escaping () -> String) {
        self.style = style
        self.whereFields = whereFields
        self.fields = fields
    }
    
    public init(style: Style = GROQuery.defaultStyle, @GROQueryBuilder whereFields: @escaping QueryBuilderHandler) {
        self.style = style
        self.whereFields = whereFields
        self.fields = { nil }
    }
    
    public override init() {
        self.style = GROQuery.defaultStyle
        self.whereFields = nil
        self.fields = { nil }
    }
    
    public var query: String {
        var filterQuery = "\(scope.rawValue)"
        if let (queryFields, rootFields) = whereFields?() {
            rootFields.forEach {
                if $0.isArray {
                    var array = (self.value(forKeyPath: $0.attachKeyPath) as? [Any]) ?? []
                    array.append($0)
                    self.setValue(array, forKeyPath: $0.attachKeyPath)
                } else {
                    self.setValue($0, forKeyPath: $0.attachKeyPath)
                }
            }
            filterQuery += "[\(queryFields.groqWhereFieldText)]"
        }
        
        let query = {
            let fieldProjection = fields()
            if let fieldProjection {
                return filterQuery + style.format(fieldProjection: fieldProjection)
            } else {
                return filterQuery
            }
        }()
        
        let orders = self.order
            .map { $0.groqWhereFieldText }
            .reduce("", +)
        
        return query + orders + slice.groqWhereFieldText
    }
    
    public subscript(range: Range<Int>) -> GROQuery {
        self.underlyingSlice = Slice(range)
        return self
    }
    
    public subscript(range: ClosedRange<Int>) -> GROQuery {
        self.underlyingSlice = Slice(range)
        return self
    }
    
    public subscript(index: Int) -> GROQuery {
        self.underlyingSlice = Slice(index)
        return self
    }
}

extension GROQuery {
    
    public enum Scope: String {
        case all = "*"
    }
    
    public enum Style {
        case multiline
        case oneline
        
        func format(fieldProjection: String) -> String {
            switch self {
            case .multiline:
                let spaces = String(repeating: " ", count: 2)
                let fields = fieldProjection
                    .replacingOccurrences(of: "\n", with: "\n\(spaces)")
                return " {\(fields)\n}"
            case .oneline:
                let fields = fieldProjection
                    .replacingOccurrences(of: "\n", with: " ")
                return " {\(fields) }"
            }
        }
    }
    
}
