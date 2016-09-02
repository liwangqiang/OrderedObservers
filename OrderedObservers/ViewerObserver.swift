//
//  ViewerObserver.swift
//  OrderedObservers
//
//  Created by 李王强 on 16/9/2.
//  Copyright © 2016年 personal. All rights reserved.
//

import Foundation


typealias ViewerObserverHandler = ((NSNotificationCenter.ViewerNotification, AnyObject?, [String : AnyObject]?) -> Void)

class ViewerObserver: NSObject {
    
    enum Priority: Int {
        case Low = 0
        case Default = 1
        case High = 2
    }
    
    var handler: ViewerObserverHandler
    var priority: Priority
    
    init(priority: Priority = .Default, handler: ViewerObserverHandler) {
        self.priority = priority
        self.handler = handler
    }
    
}