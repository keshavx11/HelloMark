//
//  ChatViewController.swift
//  HelloMark
//
//  Created by Abhigyan Singh on 20/01/17.
//  Copyright © 2017 HelloMark. All rights reserved.
//

import UIKit
import ApiAI
import MBProgressHUD

class ChatViewController: UIViewController {

    @IBOutlet var textField: UITextField? = nil
    
    @IBAction func sendText(_ sender: UIButton)
    {
        let hud = MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        
        self.textField?.resignFirstResponder()
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.textField?.text {
            request?.query = [text]
        } else {
            request?.query = [""]
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
//            if response.result.action == "money" {
//                if let parameters = response.result.parameters as? [String: AIResponseParameter]{
//                    let amount = parameters["amout"]!.stringValue
//                    let currency = parameters["currency"]!.stringValue
//                    let date = parameters["date"]!.dateValue
//                    
//                    print("Spended \(amount) of \(currency) on \(date)")
//                }
//            }
        }, failure: { (request, error) in
            // TODO: handle error
        })
        
        request?.setCompletionBlockSuccess({[unowned self] (request, response) -> Void in
            print(response)
            
            hud.hide(animated: true)
            }, failure: { (request, error) -> Void in
                hud.hide(animated: true)
        });
        
        ApiAI.shared().enqueue(request)
    }
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


