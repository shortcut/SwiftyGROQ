//
//  Logger.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 11/05/2023.
//

import Foundation

struct Logger {
    
    private init() {}
    
    static func log(_ message: @autoclosure @escaping () -> Any?) {
        #if DEBUG
        print(message() ?? "")
        #endif
    }
    
    static func warn(_ warning: Warning) {
        #if DEBUG
        print("Warning: \(warning.message)")
        #endif
    }
    
}

extension Logger {
    
    enum Warning {
        /// Warning to present if a float value is `NaN` or `infinity`.
        case floatValueIsNotFinite
        
        /// Warning to present if a dictionary cannot be encoded.
        case cannotEncodeDictionary(Error?)
        
        var message: String {
            switch self {
            case .floatValueIsNotFinite:
                return "The floating point value provided is NaN or infinite. Will be coerced to null."
            case .cannotEncodeDictionary(let error):
                let base = "The dictionary cannot be encoded. Coercing to empty dictionary. "
                if let error {
                    return base + "Error: \(error.localizedDescription)"
                }
                return base
            }
        }
    }
    
}
