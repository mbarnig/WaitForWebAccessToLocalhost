//
//  LocalHost.swift
//  WaitForWebAccessToLocalhost
//
//  Created by Marco Barnig on 14/11/2016.
//  Copyright © 2016 Marco Barnig. All rights reserved.
//

import Cocoa

var counter = 0

class LocalHost: NSObject {
    
    var timer = Timer() 
    var timeout = 10
    
    func doItAgain() {
        counter += 1
        if counter >= timeout {
            timer.invalidate()  // stop timer
            outputText += "\nNew connection trials stopped.\nThe server (locahost) is not available"
            DispatchQueue.main.async() {
                NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self) 
            }  // end dispatch   
        } else {
            outputText += "\nConnection trial " + String(counter)
            DispatchQueue.main.async() {
                NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self) 
            }  // end dispatch             
            self.webGET()
        }  // end if else        
    }  // end func
    
    func waitOneSecond() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.doItAgain), userInfo: nil, repeats: false)
    }  // end func
    
    func webGET() {
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        let myURL =  URL(string: "http://localhost:8042/tools/now")
        var myRequest = URLRequest(url: myURL!);
        myRequest.httpMethod = "GET";
        let myTask = mySession.dataTask(with: myRequest) {
            data, response, error in
            if error != nil {
                outputText += "\nError"
                DispatchQueue.main.async() { 
                    self.waitOneSecond() 
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)  
                }  // end dispatch
                mySession.finishTasksAndInvalidate()
                return
            } else {
                // handle data and response
                outputText += "\nSuccess\nThe server (locahost) is reachable."
                DispatchQueue.main.async() {   
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self) 
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeySuccess), object: self)                
                }  // end dispatch
            } // end if
        }  // end myTask
        myTask.resume()
    }  // end func

}  // end class
