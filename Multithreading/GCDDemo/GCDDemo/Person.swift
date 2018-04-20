//
//  Person.swift
//  GCDDemo
//
//  Created by YJHou on 2017/4/20.
//  Copyright © 2017年 houmanager@hotmail.com. All rights reserved.
//

import Foundation

class Person: NSObject {
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    func setProperty(name: String, email: String) {
        self.name = name
        randomDelay(maxDuration:  0.5)
        
        randomDelay(maxDuration:  0.5)
        self.email = email
    }
    
    override var description: String {
        return "[\(name)] \(email)"
    }
}


class ThreadSafePerson: Person {
    
    let isolationQueue = DispatchQueue(label: "com.houmananger.gcd", attributes: .concurrent)
    
    override func setProperty(name: String, email: String) {
        
        isolationQueue.async(flags: .barrier) {
            super.setProperty(name: name, email: email)
        }
    }
    
    override var description: String {
        return isolationQueue.sync { super.description }
    }
}

func randomDelay(maxDuration: Double) {
    let randomWait = arc4random_uniform(UInt32(maxDuration * Double(USEC_PER_SEC)))
    usleep(randomWait)
}

