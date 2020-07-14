//
//  Calculator_SwiftUIUITests.swift
//  Calculator SwiftUIUITests
//
//  Created by Jacob Sokora on 7/14/20.
//  Copyright © 2020 Jacob Sokora. All rights reserved.
//

import XCTest

class Calculator_SwiftUIUITests: XCTestCase {

	let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
		app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		XCTContext.runActivity(named: "Reset back to ftoc converter and clear input") { _ in
			let selectConverterButton = app.buttons["Converter"].firstMatch
			selectConverterButton.tap()
			let ftocConverterButton = app.buttons["Fahrenheit to Celcius"].firstMatch
			XCTAssert(ftocConverterButton.waitForExistence(timeout: 2), "Tapping the select converter button did not bring up the action sheet")
			ftocConverterButton.tap()
			app.buttons["C"].tap()
			XCTAssertEqual(app.textFields["Input"].firstMatch.value as? String, "ºF", "Failed to reset input")
			XCTAssertEqual(app.textFields["Output"].firstMatch.value as? String, "ºC", "Failed to reset output")
		}
    }

	func testMilesToKilometersConverter() {
		XCTContext.runActivity(named: "Select the miles to kilometers converter") { _ in
			let selectConverterButton = app.buttons["Converter"].firstMatch
			selectConverterButton.tap()
			print(app.debugDescription)
			let mtokConverterButton = app.buttons["Miles to Kilometers"].firstMatch
			XCTAssert(mtokConverterButton.waitForExistence(timeout: 2), "Tapping the select converter button did not bring up the action sheet")
			mtokConverterButton.tap()
		}
		let input = app.textFields["Input"].firstMatch
		let output = app.textFields["Output"].firstMatch
		XCTContext.runActivity(named: "Verify that the input and output fields have changed") { _ in
			XCTAssertEqual(input.value as? String, "m", "Converter input type not properly set to miles")
			XCTAssertEqual(output.value as? String, "km", "Converter output type not properly set to kilometers")
		}
		XCTContext.runActivity(named: "Enter 10 and verify output as 16.093 km") { _ in
			app.buttons["1"].firstMatch.tap()
			app.buttons["0"].firstMatch.tap()
			XCTAssertEqual(output.value as? String, "16.093 km", "Improper value in output field")
		}
	}
}
