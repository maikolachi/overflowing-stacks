//
//  ViewViewModelTests.swift
//  Overflowing StacksTests
//
//  Created by Faisal Bhombal on 1/15/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import XCTest
@testable import Overflowing_Stacks

class ViewViewModelTests: XCTestCase {

    let viewModel = MasterViewViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchQuestions() {
        
        let exp = expectation(description: "Wait for fetch")
//        let endEpoch = 1578967912 - 10000
        var allq = [SOVFQuestionDataModel]()
        var pages = 0
        // a 24 hour interval around the 16th of Jan
        viewModel.fetchRecentQuestions(startEpoch: 1579097911, endEpoch: 1579184311) { (questions, hasMore, quotaMax, quotaRemaining, error) in
            
            if let _ = error {
                XCTFail()
                exp.fulfill()
            } else if let q = questions {
                pages += 1
                print( "\(quotaRemaining)/\(quotaMax): \(q.count) questions")
                allq.append(contentsOf: q)
                if !hasMore {
                    exp.fulfill()
                }
            }
            
        }
    
        waitForExpectations(timeout: 30.0, handler: nil)
        
        // Test counts may change in the future - if pagesize is changed in query, pages will change
//        XCTAssert(allq.count == 652)
//        XCTAssert(pages == 53)
        
        
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
