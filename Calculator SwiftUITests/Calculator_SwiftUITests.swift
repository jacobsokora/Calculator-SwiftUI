//
//  Calculator_SwiftUITests.swift
//  Calculator SwiftUITests
//
//  Created by Jacob Sokora on 7/14/20.
//  Copyright © 2020 Jacob Sokora. All rights reserved.
//

import XCTest
@testable import Calculator_SwiftUI

class Calculator_SwiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testMilesToKilometersConverter() {
		let converter = Converter.mtok
		let conversion = converter.converter(10)
		XCTAssertEqual(conversion, 16.09, accuracy: 2) //Actually 16.0934
	}
}
