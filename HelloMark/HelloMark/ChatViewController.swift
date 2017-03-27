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
import Speech
import PubNub

class ChatViewController: UIViewController, SFSpeechRecognizerDelegate, PNObjectEventListener {
    
    var client: PubNub!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBAction func publish() {
        var publishJSON: NSDictionary!
        
        publishJSON = ["text": textView.text]
        
        print("publishing..")
        self.client.publish(publishJSON, toChannel: "speechRecog",
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

        microphoneButton.isEnabled = false  //2
        speechRecognizer?.delegate = self  //3
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            var isButtonEnabled = false

            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    @IBAction func microphoneTapped(_ sender: AnyObject) {
        
        label.text = "Say something, I'm listening!"
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(stopRecord), userInfo: nil, repeats: false)
        microphoneButton.isEnabled = false
        startRecording()
        
    }
    
    func stopRecord(){
        if audioEngine.isRunning {
            label.text = "Press Record Button!"
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = true
        }
    }
    
  /*  @IBAction func sendText(_ sender: UIButton)
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
            print(response.result.action)
            print(111)
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
//            print(response)
            
            hud.hide(animated: true)
            }, failure: { (request, error) -> Void in
                hud.hide(animated: true)
        });
        
        ApiAI.shared().enqueue(request)
    }*/
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = ""
        
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    @IBAction func backBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
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


