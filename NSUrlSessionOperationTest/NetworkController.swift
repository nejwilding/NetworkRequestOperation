//
//  NetworkController.swift
//  NSUrlSessionOperationTest
//
//  Created by Nicholas Wilding on 06/06/2016.
//  Copyright © 2016 Nicholas Wilding. All rights reserved.
//

import UIKit
import CoreData
class NetworkController: NSObject {
    let queue = NSOperationQueue()
    let mainContext: NSManagedObjectContext? = nil
    
    func requestMyData() -> NSFetchedResultsController {
        return NSFetchedResultsController()
    }

    func requestMyData(completion: (Void) -> Bool) {
        let operation = HLNetworkRequest(myParam1: "test")
        
        queue.addOperation(operation)
        completion()
    }
}



