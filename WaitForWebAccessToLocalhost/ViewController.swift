//
//  ViewController.swift
//  WaitForWebAccessToLocalhost
//
//  Created by Marco Barnig on 11/11/2016.
//  Copyright © 2016 Marco Barnig. All rights reserved.
//

import Cocoa
import WebKit

let notifyKeyOutput = "output"
let notifyKeySuccess = "success"

var outputText = ""

class ViewController: NSViewController {
    
    let localHost = LocalHost()
        
    @IBOutlet var myTextView: NSTextView!
    @IBOutlet weak var myWebView: WebView!
    
    @IBAction func startConnection(_ sender: Any) {
        outputText += "Connection trials started"
        output()
        counter = 0
        localHost.webGET()
    }  // end func
    
    func startWeb() {
        let urlString = "http://localhost:8042"
        self.myWebView.mainFrame.load(URLRequest(url: URL(string: urlString)!))  
    }  // end func
    
    @IBAction func startWithoutTest(_ sender: Any) {
        let urlString = "http://localhost:8042"
        self.myWebView.mainFrame.load(URLRequest(url: URL(string: urlString)!))       
    }  // end func  
    
    func output() {
        myTextView.string = outputText
        myTextView.scrollToEndOfDocument(self)      
    }  // end func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.startWeb), name: NSNotification.Name(rawValue: notifyKeySuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.output), name: NSNotification.Name(rawValue: notifyKeyOutput), object: nil)    
    }  // end func

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}  // end class

