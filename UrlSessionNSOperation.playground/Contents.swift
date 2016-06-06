//: Playground - noun: a place where people can play

import UIKit
import CoreData

class NetworkController: NSObject {
    let queue = NSOperationQueue()
    let mainContext: NSManagedObjectContext? = nil
    
    func requestMyData() {
        let operation = MyNetworkRequest()
        queue.addOperation(operation)
    }
    
//    func requestMyData() -> NSFetchedResultsController {
//        return NSFetchedResultsController()
//    }
//    
//    func requestMyData(completion: (Void) -> Bool) {
//        
//    }
}

class MyNetworkRequest: NSOperation, NSURLSessionDataDelegate {
    var context: NSManagedObjectContext?
    
    private var innerContext: NSManagedObjectContext?
    private var task: NSURLSessionTask?
    private let incomingData = NSMutableData()
    var sessionTask: NSURLSessionTask?
    
    lazy var session = NSURLSession.sharedSession()
    
//    init(myParam1: String, myParam2: String) {
//        super.init()
//        //set some parameters here
//    }
    
    override func start() {
        if cancelled {
            finished = true
            return
        }
        guard let url = NSURL(string: "http://localhost:9000/admin/courses/1/lessons") else {
            fatalError("URL is in error") }
        let request = NSMutableURLRequest(URL: url)
        
        sessionTask = session.dataTaskWithRequest(request)
        sessionTask?.resume()
        print("start")
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
        print("status code")
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if cancelled {
            finished = true
            sessionTask?.cancel()
            return
        }
        print("icoming data")
        incomingData.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if cancelled {
            finished = true
            sessionTask?.cancel()
            return
        }
        if NSThread.isMainThread() { print("main thread") }
        if error != nil {
            print("error me in")
            finished = true
            return
        }
        print("process data")
        finished = true
    }
}

let r = NetworkController()
r.requestMyData()
