//
//  NotificationCenter+ViewerExtension.swift
//  OrderedObservers
//
//  Created by 李王强 on 16/9/1.
//  Copyright © 2016年 personal. All rights reserved.
//

import Foundation

public var viewerNotificationTypeKey = "DocumentViewerNotificationType"
public var viewerNotificationName = "DocumentViewerNotification"

extension NSNotificationCenter {

    public enum ViewerNotification: String, Equatable {
        case Start
        case End
    }
    
    
    func postViewerNotification(note: NSNotificationCenter.ViewerNotification, object: AnyObject?, userInfo: [String : AnyObject]?) {
        guard userInfo?[viewerNotificationTypeKey] == nil else {
            fatalError()
        }
        
        var containedTypeUserInfo = userInfo ?? [:]
        containedTypeUserInfo.updateValue(note.rawValue, forKey: viewerNotificationTypeKey)
        
        self.postNotificationName(viewerNotificationName, object: object, userInfo: containedTypeUserInfo)
    }
    
    
    func test() -> Bool {
        return ViewerNotification.Start == ViewerNotification.End
    }

}

public func ==(lt: NSNotificationCenter.ViewerNotification, rt: NSNotificationCenter.ViewerNotification ) -> Bool {
    return lt.rawValue == rt.rawValue
}