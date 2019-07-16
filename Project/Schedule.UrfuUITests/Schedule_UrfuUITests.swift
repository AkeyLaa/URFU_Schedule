//
//  Schedule_UrfuUITests.swift
//  Schedule.UrfuUITests
//
//  Created by Sergey on 05/07/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import XCTest

class Schedule_UrfuUITests: XCTestCase {

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

    func testExample() {
        
        let app = XCUIApplication()
        app.navigationBars.buttons["Search"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["МЕН-180208"]/*[[".cells.staticTexts[\"МЕН-180208\"]",".staticTexts[\"МЕН-180208\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.otherElements.containing(.navigationBar, identifier:"МЕН-180207").children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .table).element/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["МЕН-180410"]/*[[".cells.staticTexts[\"МЕН-180410\"]",".staticTexts[\"МЕН-180410\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }

}
