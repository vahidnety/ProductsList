//
//  ProductsListUITests.swift
//  ProductsListUITests
//
//  Created by Vahid on 18/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import XCTest

class ProductsListUITests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        //        let app = XCUIApplication()
        //        app.launch()

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        takeScreenShots()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    func takeScreenShots() {
        let app = XCUIApplication()
        XCUIDevice.shared.orientation = .portrait

        // tableview
        let tableView = app.tables.containing(.table, identifier: "ProductsList")
        XCTAssertTrue(tableView.cells.count > 0)
        snapshot("1-Products List")
        sleep(3)

        // search bar
        let search = app.searchFields["Search"]
        search.tap()
        search.typeText("Te")
        XCTAssertTrue(tableView.cells.count > 0)
        snapshot("2-Product search")
        sleep(1)

        // scope button
        XCTAssertTrue(app.buttons["Price"].exists)
        app.buttons["Price"].tap()
        XCTAssertTrue(tableView.cells.count > 0)
        snapshot("3-Product Sort by Price")
        sleep(1)

        // tap tableview
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Ice Tea"].exists)
        snapshot("4-Product Detail")
        sleep(1)

        // edit note and typing with keyboard
        let textField = app.textFields["EditNote"]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText("test")
        snapshot("5-edit note")
        sleep(1)

        // back navigation
        let backBtn = app.buttons["Products List"]
        XCTAssertTrue(backBtn.exists)
        backBtn.tap()
        snapshot("6-Back navigation")
        sleep(1)
    }
}
