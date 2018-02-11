//
//  SendMessageViewController.swift
//  ios
//
//  Created by Yumin Zhang on 2/11/18.
//  Copyright © 2018 Yiqin Zhou. All rights reserved.
//

import UIKit

class SendMessageViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var textF: UITextField!
    
    
    var passedDict: [String:String]=[:]
    
    var myStringx=String()
    
    @IBAction func sendMessage(_ sender: Any) {
        SendMessage(textContent: textF.text!)
        loadSuccessController()
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl.text = "whatever"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        var textinfo = "hi my name is "
        textinfo += passedDict["first_name"]!
        textinfo += ". My phone number is 123-456-7890."
        myStringx = textinfo
        //myStringx="hhh"
        
        // move this model somewhere in the new view
        /*
         tested did work
         let messageReceiver = self.contactinfo["phone_number"]
         let message = "this is xxz"
         SendMessage(textContent : message, toPerson : messageReceiver!)
         */
        
        lbl.text = myStringx
        textF.delegate = self
        textF.isHidden = true
        lbl.isUserInteractionEnabled = true
        let aSelector : Selector = #selector(AddContactViewController.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        lbl.addGestureRecognizer(tapGesture)
        
    }
    
    private func loadSuccessController() {
        
        
        let alert = UIAlertController(title: nil, message: "Success", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        //loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        alert.addAction(okAction)
        
    }
    

    
    func lblTapped(){
        lbl.isHidden = true
        textF.isHidden = false
        textF.text = lbl.text
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        textF.isHidden = true
        lbl.isHidden = false
        lbl.text = textF.text
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SendMessage(textContent: String) {
        
        print ("send message called ")
        
        var request = URLRequest(url: NSURL(string: "https://api.catapult.inetwork.com/v1/users/u-2j6eew23n4z4s7wrdzyj5ey/messages")! as URL)
        request.httpMethod = "POST"
        
        let loginData = String(format: "%@:%@", "t-5m2durjfxxj4vh5kbpetega", "ewy4epz24p26ridgegp56yhwfkkgodry2jmgofq").data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var toPerson = self.passedDict["phone_number"]
        
        // for testing purpose, comment out the following line if want real number from card
        toPerson = "+18572225869"
        
        let body = ["to" : toPerson,  // change here
            "from" : "+19842198388",
            "text" : textContent // change to textContent here
        ]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print( "try throw an error")
        }
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else {
                print ("did not get data")
                return
            }
            
            }.resume()
        
        print ("message finish")
        
        
        
        //        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        //            UIAlertAction in
        //            NSLog("OK Pressed")
        //        }
        //        alert.addAction(okAction)
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
