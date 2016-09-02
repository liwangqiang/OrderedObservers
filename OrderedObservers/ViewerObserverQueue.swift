//
//  ViewerObserverQueue.swift
//  OrderedObservers
//
//  Created by 李王强 on 16/9/1.
//  Copyright © 2016年 personal. All rights reserved.
//

import UIKit

class ViewerObserverQueue {
    
    static private var _shared: ViewerObserverQueue = ViewerObserverQueue()
    
    static func sharedQueue() -> ViewerObserverQueue {
        return _shared
    }
    
    private var privateObservers: [ViewerObserver] = []
    private var token: NSObjectProtocol?
    
    init() {
        token = NSNotificationCenter.defaultCenter().addObserverForName(viewerNotificationName, object: nil, queue: nil, usingBlock: { [unowned self] (note) in
            guard let typeRawValue = note.userInfo?[viewerNotificationTypeKey] as? String, type = NSNotificationCenter.ViewerNotification(rawValue: typeRawValue), userInfo = note.userInfo as? [String : AnyObject]? else {
                fatalError()
            }
            
            self.privateObservers.forEach({ (observer) in
                observer.handler(type, note.object, userInfo)
            })
        })
        
    }
    
    deinit {
        if let token = token {
            NSNotificationCenter.defaultCenter().removeObserver(token)
        }
    }
    
    func addViewerObserver(observer: ViewerObserver) {
        privateObservers.append(observer)
        privateObservers.sortInPlace { (left, right) -> Bool in
            return left.priority.rawValue > right.priority.rawValue
        }
    }
}
