//
//  Session.swift
//  OverflowingStacks
//
//  Created by Faisal Bhombal on 1/13/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import Foundation

// Singleton to queue operations
class Session {
    static let shared = Session()
    private init() {}
    
    var urlSessionQueue = OperationQueue()
    
}

enum OperationState {
    case ready
    case executing
    case finished
}

class FetchQuestions: Operation {
    
    override var isReady: Bool {
        return false
    }
    
    
    
    override func main() {
        
    }
    
    override func cancel() {
        
    }
}
