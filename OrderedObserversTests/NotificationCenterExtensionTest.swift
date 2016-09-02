//
//  NotificationCenterExtensionTest.swift
//  OrderedObservers
//
//  Created by 李王强 on 16/9/1.
//  Copyright © 2016年 personal. All rights reserved.
//

import XCTest
@testable import OrderedObservers

class NotificationCenterExtensionTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPostingViewerNotification_Successful() {
        
        let viewerNote = NSNotificationCenter.ViewerNotification.Start
        _ = expectationForNotification(viewerNotificationName, object: self) { note  -> Bool in
            
            guard let typeRawValue = note.userInfo?[viewerNotificationTypeKey] as? String else{
                XCTFail()
                return false
            }
            let type = NSNotificationCenter.ViewerNotification(rawValue: typeRawValue)
            XCTAssertEqual(type?.rawValue, viewerNote.rawValue)
            
            return true
        }
        
        NSNotificationCenter.defaultCenter().postViewerNotification(viewerNote, object: self, userInfo: nil)
        
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testPostingViewerNotification_WithCorrectUserInfo() {
        let viewerNote = NSNotificationCenter.ViewerNotification.Start
        _ = expectationForNotification(viewerNotificationName, object: self) { note  -> Bool in
            XCTAssertEqual(note.userInfo?["data"] as? String, "it's ok")
            
            return true
        }
        
        NSNotificationCenter.defaultCenter().postViewerNotification(viewerNote, object: self, userInfo: ["data": "it's ok"])
        
        waitForExpectationsWithTimeout(3, handler: nil)
    
    }

}
