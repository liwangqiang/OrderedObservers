//
//  ViewerNotificationObserverQueueTest.swift
//  OrderedObservers
//
//  Created by 李王强 on 16/9/1.
//  Copyright © 2016年 personal. All rights reserved.
//

import XCTest
@testable import OrderedObservers

class ViewerNotificationObserverQueueTest: XCTestCase {
    
    var sut: ViewerObserverQueue!

    override func setUp() {
        super.setUp()
        
        sut = ViewerObserverQueue.sharedQueue()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testObserverQueue_SharedQueue() {
        XCTAssertTrue(sut === ViewerObserverQueue.sharedQueue())
    }
    
    func testObserverQueue_AddingObserver() {
        let expectation = expectationWithDescription("handler get called")
        
        let fakedSender = NSObject()
        let observer = ViewerObserver { type, sender, userInfo in
            guard sender as? NSObject === fakedSender else {
                return
            }
            expectation.fulfill()
            XCTAssertEqual(userInfo?["data"] as? String, "it's ok")
        }
        
        sut.addViewerObserver(observer)
        NSNotificationCenter.defaultCenter().postViewerNotification(.Start, object: fakedSender, userInfo: ["data": "it's ok"])
        
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testObserverQueue_priority() {
        let expectation = expectationWithDescription("hander get called")
        
        let fakedSender = NSObject()
        var lowPriorityObserverHandlerDidCall = false
        var defaultPriorityObserverHandlerDidCall = false
        var highPriorityObserverHandlerDidCall = false
        
        let lowPriorityObserver = ViewerObserver(priority: .Low, handler: { (type, sender, userInfo) in
            guard sender as? NSObject === fakedSender else {
                return
            }
            
            XCTAssertTrue(!lowPriorityObserverHandlerDidCall)
            XCTAssertTrue(defaultPriorityObserverHandlerDidCall)
            XCTAssertTrue(highPriorityObserverHandlerDidCall)
            
            lowPriorityObserverHandlerDidCall = true
            expectation.fulfill()
        })
        
        let defaultPriorityObserver = ViewerObserver(priority: .Default, handler: { (type, sender, userInfo) in
            guard sender as? NSObject === fakedSender else {
                return
            }
            
            XCTAssertTrue(!lowPriorityObserverHandlerDidCall)
            XCTAssertTrue(!defaultPriorityObserverHandlerDidCall)
            XCTAssertTrue(highPriorityObserverHandlerDidCall)
            
            defaultPriorityObserverHandlerDidCall = true
        })
        
        let HighPriorityObserver = ViewerObserver(priority: .High, handler: { (type, sender, userInfo) in
            guard sender as? NSObject === fakedSender else {
                return
            }
            
            XCTAssertTrue(!lowPriorityObserverHandlerDidCall)
            XCTAssertTrue(!defaultPriorityObserverHandlerDidCall)
            XCTAssertTrue(!highPriorityObserverHandlerDidCall)
            
            highPriorityObserverHandlerDidCall = true
        })
        
        sut.addViewerObserver(lowPriorityObserver)
        sut.addViewerObserver(HighPriorityObserver)
        sut.addViewerObserver(defaultPriorityObserver)
        
        NSNotificationCenter.defaultCenter().postViewerNotification(.Start, object: fakedSender, userInfo: nil)
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    

}
