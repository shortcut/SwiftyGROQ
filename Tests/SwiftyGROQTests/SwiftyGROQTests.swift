import XCTest
@testable import SwiftyGROQ

final class SwiftyGROQTests: XCTestCase {
    
    func testEverythingWithNoFiltersApplied() throws {
        let query = GROQuery()
        
        XCTAssertEqual(query.query, "*")
    }
    
    func testIDEquals() throws {
        let query = GROQuery {
            Equal("_id", "abc.123")
        }
        
        XCTAssertEqual(query.query, "*[_id == \"abc.123\"]")
    }
    
    func testOperatorsIDEquals() throws {
        let query = GROQuery {
            SpecialGROQKey.id == "abc.123"
        }
        
        XCTAssertEqual(query.query, "*[_id == \"abc.123\"]")
    }
    
    func testInArray() throws {
        let query = GROQuery {
            In(SpecialGROQKey.type, ["movie", "person"])
        }
        
        print(query.query)
        XCTAssertEqual(query.query, "*[_type in [\"movie\", \"person\"]]")
    }
    
    func testMultipleFiltersAnd() throws {
        let query = GROQuery {
            Type("movie")
            GreaterThan("popularity", 15)
            GreaterThan("releaseDate", "2016-04-25")
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\" && popularity > 15 && releaseDate > \"2016-04-25\"]")
    }
    
    func testMultipleFiltersOr() throws {
        let query = GROQuery {
            Type("movie")
            Or {
                GreaterThan("popularity", 15)
                GreaterThan("releaseDate", "2016-04-25")
            }
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\" && popularity > 15 || releaseDate > \"2016-04-25\"]")
    }
    
    func testOperatorsMultipleFiltersOr() throws {
        let query = GROQuery {
            Type("movie")
            GreaterThan("popularity", 15)
            || GreaterThan("releaseDate", "2016-04-25")
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\" && popularity > 15 || releaseDate > \"2016-04-25\"]")
    }
    
    func testLessThan() throws {
        let query = GROQuery {
            LessThan("popularity", 15)
        }
        
        XCTAssertEqual(query.query, "*[popularity < 15]")
    }
    
    func testOperatorsLessThan() throws {
        let query = GROQuery {
            "popularity" < 15
        }
        
        XCTAssertEqual(query.query, "*[popularity < 15]")
    }
    
    func testGreaterThan() throws {
        let query = GROQuery {
            GreaterThan("popularity", 15)
        }
        
        XCTAssertEqual(query.query, "*[popularity > 15]")
    }
    
    func testOperatorsGreaterThan() throws {
        let query = GROQuery {
            "popularity" > 15
        }
        
        XCTAssertEqual(query.query, "*[popularity > 15]")
    }
    
    func testLessThanOrEqual() throws {
        let query = GROQuery {
            LessThanOrEqual("popularity", 15)
        }
        
        XCTAssertEqual(query.query, "*[popularity <= 15]")
    }
    
    func testOperatorsLessThanOrEqual() throws {
        let query = GROQuery {
            "popularity" <= 15
        }
        
        XCTAssertEqual(query.query, "*[popularity <= 15]")
    }
    
    func testGreaterThanOrEqual() throws {
        let query = GROQuery {
            GreaterThanOrEqual("popularity", 15)
        }
        
        XCTAssertEqual(query.query, "*[popularity >= 15]")
    }
    
    func testOperatorsGreaterThanOrEqual() throws {
        let query = GROQuery {
            "popularity" >= 15
        }
        
        XCTAssertEqual(query.query, "*[popularity >= 15]")
    }
    
    func testNotEqual() throws {
        let query = GROQuery {
            NotEqual("releaseDate", "2016-04-27")
        }
        
        XCTAssertEqual(query.query, "*[releaseDate != \"2016-04-27\"]")
    }
    
    func testOperatorsNotEqual() throws {
        let query = GROQuery {
            "releaseDate" != "2016-04-27"
        }
        
        XCTAssertEqual(query.query, "*[releaseDate != \"2016-04-27\"]")
    }
    
    func testNot() throws {
        let query = GROQuery {
            Not(
                Equal("releaseDate", "2016-04-27")
            )
        }
        
        XCTAssertEqual(query.query, "*[!(releaseDate == \"2016-04-27\")]")
    }
    
    func testOperatorsNot() throws {
        let query = GROQuery {
            !Equal("releaseDate", "2016-04-27")
        }
        
        XCTAssertEqual(query.query, "*[!(releaseDate == \"2016-04-27\")]")
    }
    
    func testMatch() throws {
        let query = GROQuery {
            Match("title", "wo*")
        }
        
        XCTAssertEqual(query.query, "*[title match \"wo*\"]")
    }
    
    func testSlicingExclusive() throws {
        let query = GROQuery {
            Type("movie")
        }[0..<10]
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"][0...10]")
    }
    
    func testSlicingInclusive() throws {
        let query = GROQuery {
            Type("movie")
        }[0...10]
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"][0..10]")
    }
    
    func testSlicingInQueryBuilder() throws {
        let query = GROQuery {
            Type("movie")
            Slice(0..<10)
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"][0...10]")
    }
    
    func testSlicingIndexQueryBuilder() throws {
        let query = GROQuery {
            Type("movie")
            Slice(1)
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"][1]")
    }
    
    func testSlicingIndexSubscript() throws {
        let query = GROQuery {
            Type("movie")
        }[1]
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"][1]")
    }
    
    func testProjection() throws {
        let query = GROQuery {
            Type("movie")
            Slice(0..<10)
        } fields: {
            "name"
            "rating"
            "releaseDate"
        }
        
        let expectedResult = """
        *[_type == \"movie\"] {
          name,
          rating,
          releaseDate
        }[0...10]
        """
        
        XCTAssertEqual(query.query, expectedResult)
    }
    
    func testProjectionFormatMultiline() throws {
        let query = GROQuery(style: .multiline) {
            Type("movie")
        } fields: {
            "name"
            "rating"
            "releaseDate"
        }
        
        let expectedResult = """
        *[_type == \"movie\"] {
          name,
          rating,
          releaseDate
        }
        """
        
        XCTAssertEqual(query.query, expectedResult)
    }
    
    func testProjectionFormatOneline() throws {
        let query = GROQuery(style: .oneline) {
            Type("movie")
        } fields: {
            "name"
            "rating"
            "releaseDate"
        }
        
        let expectedResult = "*[_type == \"movie\"] { name, rating, releaseDate }"
        
        XCTAssertEqual(query.query, expectedResult)
    }
    
    func testOrdering() throws {
        let query = GROQuery {
            Type("movie")
        }.order(byField: SpecialGROQKey.createdAt, direction: .ascending)
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] | order(_createdAt asc)")
    }
    
    func testOrderingInQueryBuilder() throws {
        let query = GROQuery {
            Type("movie")
            Order("_createdAt", .ascending)
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] | order(_createdAt asc)")
    }
    
    func testMultipleOrdersInQueryBuilder() throws {
        let query = GROQuery {
            Type("movie")
            Order("releaseDate", .descending)
            Order("_createdAt", .ascending)
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] | order(releaseDate desc) | order(_createdAt asc)")
    }
    
    func testMultipleOrdersModifier() throws {
        let query = GROQuery {
            Type("movie")
        }.order(byField: "releaseDate", direction: .descending)
         .order(byField: "_createdAt", direction: .ascending)
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] | order(releaseDate desc) | order(_createdAt asc)")
    }
    
    func testOrderLowercase() throws {
        let query = GROQuery {
            Type("movie")
        }.order(byField: Lower("title"), direction: .ascending)
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] | order(lower(title) asc)")
    }
    
    func testRenameFields() throws {
        let query = GROQuery(style: .oneline) {
            Type("movie")
        } fields: {
            Field(renamedTo: "renamedId", SpecialGROQKey.id)
            SpecialGROQKey.type
            "title"
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] { \"renamedId\": _id, _type, title }")
    }
    
    func testAllFieldsProjection() throws {
        let query = GROQuery(style: .oneline) {
            Type("movie")
        } fields: {
            All()
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] { ... }")
    }
    
    func testCountFieldProjection() throws {
        let query = GROQuery(style: .oneline) {
            Type("movie")
        } fields: {
            Count(newFieldName: "actorCount", "actors")
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] { \"actorCount\": count(actors) }")
    }
    
    func testCoalesceFieldProjection() throws {
        let query = GROQuery(style: .oneline) {
            Type("movie")
        } fields: {
            Coalesce(newFieldName: "rating", "rating", fallbackValue: "unknown")
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] { \"rating\": coalesce(rating, \"unknown\") }")
    }
    
    func testCoalesceWithAllFieldsProjection() throws {
        let query = GROQuery(style: .oneline) {
            Type("movie")
        } fields: {
            All()
            Coalesce(newFieldName: "rating", "rating", fallbackValue: "unknown")
        }
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] { ..., \"rating\": coalesce(rating, \"unknown\") }")
    }
    
    func testCustomWhereQuery() throws {
        let query = GROQuery(style: .oneline) {
            Custom("@[\"1\"]")
        }
        
        XCTAssertEqual(query.query, "*[@[\"1\"]]")
    }
    
    func testCustomField() throws {
        let query = GROQuery(style: .oneline) {
            Type("movie")
        } fields: {
            Custom("\"popularity\": select(popularity > 20 => \"high\", popularity > 10 => \"medium\", popularity <= 10 => \"low\")")
        }
        
        print(query.query)
        
        let expected = "*[_type == \"movie\"] { \"popularity\": select(popularity > 20 => \"high\", popularity > 10 => \"medium\", popularity <= 10 => \"low\") }"
        
        XCTAssertEqual(query.query, expected)
    }
    
}
