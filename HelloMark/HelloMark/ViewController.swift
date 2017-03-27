//
//  ViewController.swift
//  HelloMark
//
//  Created by Keshav Bansal on 17/01/17.
//  Copyright © 2017 HelloMark. All rights reserved.
//

import UIKit
import PubNub


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PNObjectEventListener {
    
    var client: PubNub!
    @IBOutlet var swtch: UISwitch!
    var roomName: String!
    @IBOutlet var tableView: UITableView!
    var imageName = [UIImage(named: "bulb"),UIImage(named: "fan"),UIImage(named: "tv"),UIImage(named: "plug"),]
    var hexArray = ["#26CE9D","#EF1136","#CE661F","#CEC023"]
    var titleArray = ["Room Light","Fan","Television","Power Plug"]
    var subTitleArray = ["Light up the room", "Get some air", "Watch tv", "Power up an appliance"]
    

    @IBAction func backBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func publish() {
        var publishJSON: NSDictionary!
        if swtch.isOn == true{
        publishJSON = ["place": "bedroom",
                                         "device": "light",
                                         "state": true
        ]
        }else{
        publishJSON = ["place": "bedroom",
                                             "device": "light",
                                             "state": false
            ]
        }
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
        self.client = PubNub.client(with: configuration)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.imgImage.image = imageName[indexPath.row]
        cell.titleLabel?.text = titleArray[indexPath.row]
        cell.subTitleLabel?.text = subTitleArray[indexPath.row]
        cell.backgroundColor = self.hexStringToUIColor(hexArray[indexPath.row])
//        if self.radioArray[indexPath.row]==0{
//                cell.radioButton.setOn(false, animated: true)
//            
        return cell
    }
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index1 = cString.characters.index(cString.endIndex, offsetBy: -(cString.characters.count-1))
            cString = cString.substring(from: index1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

