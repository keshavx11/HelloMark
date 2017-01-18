//
//  ViewController.swift
//  HelloMark
//
//  Created by Keshav Bansal on 17/01/17.
//  Copyright © 2017 HelloMark. All rights reserved.
//

import UIKit
import PubNub

class ViewController: UIViewController, PNObjectEventListener {
    
    var client: PubNub!

    @IBAction func publish(_ sender: Any) {
        let publishJSON: NSDictionary = ["place": "bedroom",
                                         "device": "light",
                                         "state": false
        ]
        print("publishing..")
        self.client.publish(publishJSON, toChannel: "switch",
                            compressed: false, withCompletion: { (status) in
                                
                                
                                if !status.isError {
                                    print("published")
                                }
                                else{
                                    print(status.errorData)
                                    /**
                                     Handle message publish error. Check 'category' property to find
                                     out possible reason because of which request did fail.
                                     Review 'errorData' property (which has PNErrorData data type) of status
                                     object to get additional information about issue.
                                     
                                     Request can be resent using: status.retry()
                                     */
                                }
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = PNConfiguration(publishKey: "pub-c-73cca4b9-e219-4f94-90fc-02dd8f018045", subscribeKey: "sub-c-383332aa-dcc0-11e6-b6b1-02ee2ddab7fe")
        self.client = PubNub.clientWithConfiguration(configuration)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

