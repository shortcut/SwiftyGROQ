import XCTest
import SwiftyGROQ

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
    
    func testTrue() throws {
        let query = GROQuery {
            True("isPublished")
        }
        
        XCTAssertEqual(query.query, "*[isPublished]")
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
    
    func testMultipleOrdersModifierWithSlicing() throws {
        let query = GROQuery {
            Type("movie")
        }[0..<10]
            .order(byField: "releaseDate", direction: .descending)
            .order(byField: "_createdAt", direction: .ascending)
        
        XCTAssertEqual(query.query, "*[_type == \"movie\"] | order(releaseDate desc) | order(_createdAt asc)[0...10]")
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
        
        let expected = "*[_type == \"movie\"] { \"popularity\": select(popularity > 20 => \"high\", popularity > 10 => \"medium\", popularity <= 10 => \"low\") }"
        
        XCTAssertEqual(query.query, expected)
    }
    
    func testStringDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" as GROQKeyRepresentable == "string"
        }
        
        XCTAssertEqual(query.query, "*[key == \"string\"]")
    }
    
    func testIntDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == 100
        }
        
        XCTAssertEqual(query.query, "*[key == 100]")
    }
    
    func testDoubleDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == 100.0 as Double
        }
        
        XCTAssertEqual(query.query, "*[key == 100.0]")
    }
    
    func testFloatDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == 100.0 as Float
        }
        
        XCTAssertEqual(query.query, "*[key == 100.0]")
    }
    
    func testFloatNaNDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Float.nan
        }
        
        XCTAssertEqual(query.query, "*[key == null]")
    }
    
    func testFloatInfinityDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Float.infinity
        }
        
        XCTAssertEqual(query.query, "*[key == null]")
    }
    
    func testDoubleNaNDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Double.nan
        }
        
        XCTAssertEqual(query.query, "*[key == null]")
    }
    
    func testDoubleInfinityDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Double.infinity
        }
        
        XCTAssertEqual(query.query, "*[key == null]")
    }
    
    func testNullDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == NSNull()
        }
        
        XCTAssertEqual(query.query, "*[key == null]")
    }
    
    func testOptionalSomeDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Optional.some("some")
        }
        
        XCTAssertEqual(query.query, "*[key == \"some\"]")
    }
    
    func testOptionalNoneDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Optional.none
        }
        
        XCTAssertEqual(query.query, "*[key == null]")
    }
    
    func testBoolTrueDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == true
        }
        
        XCTAssertEqual(query.query, "*[key == true]")
    }
    
    func testBoolFalseDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == false
        }
        
        XCTAssertEqual(query.query, "*[key == false]")
    }
    
    func testArrayDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == ["abc", 123, 3.14, true, NSNull()]
        }
        
        XCTAssertEqual(query.query, "*[key == [\"abc\", 123, 3.14, true, null]]")
    }
    
    func testDateDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Date(timeIntervalSince1970: 0)
        }
        
        XCTAssertEqual(query.query, "*[key == \"1970-01-01T00:00:00Z\"]")
    }
    
    func testDateISO8601FormatDataType() throws {
        let date = Date()
        let dateString = ISO8601DateFormatter().string(from: date)
        let query = GROQuery(style: .oneline) {
            "key" == date
        }
        
        XCTAssertEqual(query.query, "*[key == \"\(dateString)\"]")
    }
    
    func testDictionaryDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == [
                "a": "abc",
                "b": 123,
                "c": ["a": 1, "b": 2],
                "d": [true, false],
                "e": NSNull()
            ]
        }
        
        XCTAssertEqual(query.query, "*[key == {\"a\":\"abc\",\"b\":123,\"c\":{\"a\":1,\"b\":2},\"d\":[true,false],\"e\":null}]")
    }
    
    func testPairDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Pair("abc", 123)
        }
        
        XCTAssertEqual(query.query, "*[key == \"abc\" => 123]")
    }
    
    func testPairFromTupleDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Pair((1, 2))
        }
        
        XCTAssertEqual(query.query, "*[key == 1 => 2]")
    }
    
    func testRangeDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == 0..<10
        }
        
        XCTAssertEqual(query.query, "*[key == 0...10]")
    }
    
    func testClosedRangeDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == 0...10
        }
        
        XCTAssertEqual(query.query, "*[key == 0..10]")
    }
    
    func testNSRangeDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == NSRange(location: 0, length: 10)
        }
        
        XCTAssertEqual(query.query, "*[key == 0...10]")
    }
    
    func testPathFromArrayDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Path(["articles", "business", "finance", "4861"])
        }
        
        XCTAssertEqual(query.query, "*[key == \"articles.business.finance.4861\"]")
    }
    
    func testPathFromVariadicArgumentsDataType() throws {
        let query = GROQuery(style: .oneline) {
            "key" == Path("articles", "business", "finance", "*")
        }
        
        XCTAssertEqual(query.query, "*[key == \"articles.business.finance.*\"]")
    }
    
}
