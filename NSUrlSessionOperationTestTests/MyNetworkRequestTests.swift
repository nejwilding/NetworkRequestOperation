//
//  NSUrlSessionOperationTestTests.swift
//  NSUrlSessionOperationTestTests
//
//  Created by Nicholas Wilding on 06/06/2016.
//  Copyright © 2016 Nicholas Wilding. All rights reserved.
//

import XCTest
@testable import NSUrlSessionOperationTest

class MyNetworkRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testThat_Operation_Finishes() {
        // given
        let operation = MockNetworkRequest(myParam1: "test")
        var finished = false
        
        //when
        let expectation = expectationWithDescription("expectation")
        operation.completionBlock = {
            finished = operation.finished
            // then
            XCTAssertEqual(finished, true)
            expectation.fulfill()
        }
        
       let queue = NSOperationQueue.mainQueue()
        queue.addOperation(operation)

        waitForExpectationsWithTimeout(20.0, handler: nil)
    }
    
    func testThat_Operation_DoesNotCancel() {
        // given
        let operation = MockNetworkRequest(myParam1: "test")
        var cancelled = false
        let expectation = expectationWithDescription("expectation")
        
        // when
        operation.completionBlock = {
            cancelled = operation.cancelled
            XCTAssertEqual(cancelled, false)
            expectation.fulfill()
        }
        
        let queue = NSOperationQueue.mainQueue()
        queue.addOperation(operation)
        
        waitForExpectationsWithTimeout(20.0, handler: nil)

    }
    
    func test_Operation_CallsProcessData() {
        // given
        let operation = MockNetworkRequest(myParam1: "test")
        var didCallProcessData = false
        let expectation = expectationWithDescription("expectation")
        
        // when
        operation.completionBlock = {
            didCallProcessData = operation.didProcessData
            XCTAssertEqual(didCallProcessData, true)
            expectation.fulfill()
        }
        
        let queue = NSOperationQueue.mainQueue()
        queue.addOperation(operation)
        
        waitForExpectationsWithTimeout(20.0, handler: nil)
    }
    
    func test_Operation_HasNoError() {
        // given
        let operation = MockNetworkRequest(myParam1: "test")
        var hasError = false
        let expectation = expectationWithDescription("expectation")
        
        // when
        operation.completionBlock = {
            if let _ = operation.sessionError {
                hasError = true
            }
            XCTAssertEqual(hasError, false)
            expectation.fulfill()
        }
        
        let queue = NSOperationQueue.mainQueue()
        queue.addOperation(operation)
        
        waitForExpectationsWithTimeout(20.0, handler: nil)
    }
}

extension MyNetworkRequestTests {
    
    class MockNetworkRequest: HLNetworkRequest  {
        var didProcessData = false
        
        override func processData() {
            didProcessData = true
        }
    }
}

