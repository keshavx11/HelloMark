//
//  HomeViewController.swift
//  HelloMark
//
//  Created by Keshav Bansal on 21/01/17.
//  Copyright © 2017 HelloMark. All rights reserved.
//

import UIKit
import PubNub

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, PNObjectEventListener {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var lockLabel: UILabel!
    var isReady: Bool = false
    @IBOutlet var lockButton: UIButton!
    @IBOutlet var actInd1: UIActivityIndicatorView!
    @IBOutlet var actInd2: UIActivityIndicatorView!
    
    var imageName = [UIImage(named: "bedroom"),UIImage(named: "kitchen"),UIImage(named: "dining"),UIImage(named: "living"),]
    
    var nameArray = ["Bedroom","Kitchen","Dining Room","Living Room"]
    var publishNameArray = ["bedroom","kitchen","diningRoom","livingRoom"]
    
    var client: PubNub!
    
    @IBAction func lockBtn(_ sender: AnyObject) {
        if sender.tag == 0{
            self.lockButton.setBackgroundImage(UIImage(named: "locked"), for: UIControlState.normal)
            self.lockLabel.text = "Lock: On"
            lockButton.tag = 1
        }else{
            self.lockButton.setBackgroundImage(UIImage(named: "unlocked"), for: UIControlState.normal)
            self.lockLabel.text = "Lock: Off"
            lockButton.tag = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imgImage.image = imageName[indexPath.row]
        cell.lblName.text! = nameArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let MainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let desCV = MainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        desCV.roomName = publishNameArray[indexPath.row]
        self.navigationController?.pushViewController(desCV, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 31/255.0, green: 31/255.0, blue: 31/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let configuration = PNConfiguration(publishKey: "pub-c-73cca4b9-e219-4f94-90fc-02dd8f018045", subscribeKey: "sub-c-383332aa-dcc0-11e6-b6b1-02ee2ddab7fe")
        self.client = PubNub.client(with: configuration)
        self.client.add(self as! PNObjectEventListener)
        self.client.subscribe(toChannels: ["Temp"], withPresence: false)
        
        self.lockButton.layer.cornerRadius = 4
        self.lockButton.clipsToBounds = true
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.channel != message.data.subscription {
            // Message has been received on channel group stored in message.data.subscription.
        }
        else {
            // Message has been received on channel stored in message.data.channel.
        }
        
//        print("Received message: \(message.data.message) on channel \(message.data.channel) " +
//            "at \(message.data.timetoken)")
        let dict = message.data.message as! NSDictionary
        let Temp = dict.value(forKey: "Temp")!
        let Hum = dict.value(forKey: "Hum")!
        tempLabel.text = "\(Temp)" + "°C"
        humidityLabel.text = "\(Hum)" + "%"
        actInd1.stopAnimating()
        actInd2.stopAnimating()
        tempLabel.isHidden = false
        humidityLabel.isHidden = false
    }
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        
        if status.operation == .subscribeOperation {
            
            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    
                    // This is expected for a subscribe, this means there is no error or issue whatsoever.
                }
                else {
                    
                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
            }
            else if status.category == .PNUnexpectedDisconnectCategory {
                
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {
                
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {
                    
                    /**
                     This means that PAM does allow this client to subscribe to this channel and channel group
                     configuration. This is another explicit error.
                     */
                }
                else {
                    
                    /**
                     More errors can be directly specified by creating explicit cases for other error categories
                     of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                     `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                     or `PNNetworkIssuesCategory`
                     */
                }
            }
        }
        else if status.operation == .unsubscribeOperation {
            
            if status.category == .PNDisconnectedCategory {
                
                /**
                 This is the expected category for an unsubscribe. This means there was no error in
                 unsubscribing from everything.
                 */
            }
        }
        else if status.operation == .heartbeatOperation {
            
            /**
             Heartbeat operations can in fact have errors, so it is important to check first for an error.
             For more information on how to configure heartbeat notifications through the status
             PNObjectEventListener callback, consult http://www.pubnub.com/docs/ios-objective-c/api-reference#configuration_basic_usage
             */
            
            if !status.isError { /* Heartbeat operation was successful. */ }
            else { /* There was an error with the heartbeat operation, handle here. */ }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

