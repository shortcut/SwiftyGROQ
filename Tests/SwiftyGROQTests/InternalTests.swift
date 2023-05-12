//
//  InternalTests.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 12/05/2023.
//

import XCTest
@testable import SwiftyGROQ

final class SwiftyGROQInternalTests: XCTestCase {
    
    func testGroqKeySafeRepresentation() throws {
        let query = "_now()"
        XCTAssertEqual(query.groqKeySafeRepresentation, "now")
    }
    
}
