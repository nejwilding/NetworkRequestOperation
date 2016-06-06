//
//  MyNetworkRequest.swift
//  NSUrlSessionOperationTest
//
//  Created by Nicholas Wilding on 06/06/2016.
//  Copyright © 2016 Nicholas Wilding. All rights reserved.
//

import Foundation
import CoreData

protocol DataProcessable {
    func processData()
}

class HLNetworkRequest: NSOperation, NSURLSessionDataDelegate, DataProcessable {
    var context: NSManagedObjectContext?
    
    private var innerContext: NSManagedObjectContext?
    private var task: NSURLSessionTask?
    private let incomingData = NSMutableData()
    var sessionTask: NSURLSessionTask?
    var sessionError: ErrorType?
    
    var localSession: NSURLSession {
        return NSURLSession(configuration: localConfig, delegate: self, delegateQueue: nil)
    }
    
    var localConfig: NSURLSessionConfiguration {
        return NSURLSessionConfiguration.defaultSessionConfiguration()
    }
    
    init(myParam1: String) {
        super.init()
        //set some parameters here
    }
    
    override func start() {
        if cancelled {
            finished = true
            return
        }
        guard let url = NSURL(string: "http://jsonplaceholder.typicode.com/todos") else {
            fatalError("DEBUG URL is in error") }
        let request = NSMutableURLRequest(URL: url)
        sessionTask = localSession.dataTaskWithRequest(request)
        sessionTask?.resume()
    }
    
    var internalFinished: Bool = false
    override var finished: Bool {
        get {
            return internalFinished
        }
        set (newAnswer) {
            willChangeValueForKey("isFinished")
            internalFinished = newAnswer
            didChangeValueForKey("isFinished")
        }
    }
    
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        if cancelled {
            finished = true
            sessionTask?.cancel()
            return
        }
        
        //add status code
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if cancelled {
            finished = true
            sessionTask?.cancel()
            return
        }
        incomingData.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if cancelled {
            finished = true
            sessionTask?.cancel()
            return
        }
        if NSThread.isMainThread() { print("DEBU main thread") }
        if error != nil {
            sessionError = error
            finished = true
            return
        }
        processData()
        finished = true
    }
    
    func processData() { }
}