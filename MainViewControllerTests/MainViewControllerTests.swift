//
//  MainViewControllerTests.swift
//  MainViewControllerTests
//
//  Created by Shiva Teja Celumula on 6/27/17.
//  Copyright © 2017 Photon. All rights reserved.
//

import XCTest
@testable import PathOfLowestCost

class MainViewControllerTests: XCTestCase {
    var mainVC = MainViewController()
    var lowestCostCalculator = LowestCostCalculator()
    let MaxCost = 50
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        mainVC = storyboard.instantiateInitialViewController() as! MainViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEnteredData() {
        let isEnteredTextValid = mainVC.checkForAlphabets(enteredString: "4,2,1,5,a")
        XCTAssert(isEnteredTextValid)
    }
    
    func testTotalCost() {
        let totalCost = lowestCostCalculator.totalPathCost()
        XCTAssert(totalCost > MaxCost)
    }
    
    func testPathSuccess() {
        lowestCostCalculator.matrixArray = [[3,5,6,8], [3,4,2,5], [8,12,34,1], [8,2,1,4]]
        _ = lowestCostCalculator.findPath()
        XCTAssert(lowestCostCalculator.isPathSuccess())
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
