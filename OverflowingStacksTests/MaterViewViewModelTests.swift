//
//  MaterViewViewModelTests.swift
//  OverflowingStacksTests
//
//  Created by Faisal Bhombal on 1/13/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import XCTest
@testable import OverflowingStacks

class MaterViewViewModelTests: XCTestCase {

    let masterViewModel = MasterViewViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetch() {
        
        let exp = expectation(description: "Waiting for fetch")
        
        masterViewModel.fetchRecentQuestions(startEpoch: 1578967912 - 4 * 60 * 60, endEpoch: 1578967912 ) { (error, questions) in
            print("Done")
            exp.fulfill()
        }
        waitForExpectations(timeout: 100.0, handler: nil)
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
