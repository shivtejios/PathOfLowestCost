//
//  PathOfLowestCostUITests.swift
//  PathOfLowestCostUITests
//
//  Created by Shiva Teja Celumula on 6/20/17.
//  Copyright © 2017 Photon. All rights reserved.
//

import XCTest

class PathOfLowestCostUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
        func testUISample1() {
            
            let app = XCUIApplication()
            let textField = app.otherElements.containing(.staticText, identifier:"Path Of Lowest Cost").children(matching: .textField).element
            textField.tap()
            textField.typeText("3,6,5,8,3")
            
            let enterButton = app.buttons["Enter"]
            enterButton.tap()
            textField.typeText("4,1,9,4,7")
            enterButton.tap()
            textField.typeText("1,8,3,1,2")
            enterButton.tap()
            textField.typeText("2,2,9,3,8")
            enterButton.tap()
            textField.typeText("8,7,9,2,6")
            enterButton.tap()
            textField.typeText("6,4,5,6,4")
            enterButton.tap()
            app.buttons["Find Path of Lowest Cost"].tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testUISample2() {
        
        let app = XCUIApplication()
        let textField = app.otherElements.containing(.staticText, identifier:"Path Of Lowest Cost").children(matching: .textField).element
        textField.tap()
        textField.typeText("19,21,20")
        
        let enterButton = app.buttons["Enter"]
        enterButton.tap()
        textField.tap()
        textField.typeText("10,23,12")
        enterButton.tap()
        textField.tap()
        textField.typeText("19,20,20")
        enterButton.tap()
        textField.typeText("10,19,11")
        enterButton.tap()
        textField.typeText("19,12,10")
        enterButton.tap()
        app.buttons["Find Path of Lowest Cost"].tap()
        
    }
    
    
}
