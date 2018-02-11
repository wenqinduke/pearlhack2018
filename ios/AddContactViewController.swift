//
//  AddContactViewController.swift
//  ios
//
//  Created by Wenqin Wang on 2/10/18.
//  Copyright © 2018 Yiqin Zhou. All rights reserved.
//

import UIKit
import Contacts

class AddContactViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addContacts: UIButton!
    
    @IBAction func Addcontact(_ sender: Any) {
        let contact = CNMutableContact()
        //contact.imageData = NSData() // The profile picture as a NSData object
        if self.contactinfo["first_name"] != nil{
            contact.givenName = self.contactinfo["first_name"]!
        }
        if self.contactinfo["last_name"] != nil{
            contact.familyName = self.contactinfo["last_name"]!
        }
        
        //contact.givenName = self.contactinfo["first_name"]!
        //contact.familyName = self.contactinfo["last_name"]!
        
        contact.jobTitle = "manager"
        
        // check "if x is NSNull()"
        if self.contactinfo["email_address"] != nil{
            let homie = self.contactinfo["email_address"]!
            let workEmail = CNLabeledValue(label:CNLabelHome, value: homie as NSString)
            contact.emailAddresses = [workEmail]
        }
        
        
//        let homie = self.contactinfo["email_address"]!
//        let workie = "j.appleseed@icloud.com"
//        let homeEmail = CNLabeledValue(label:CNLabelHome, value: homie as NSString)
//        let workEmail = CNLabeledValue(label:CNLabelWork, value:workie as NSString)
//        contact.emailAddresses = [homeEmail, workEmail]
        
        if self.contactinfo["phone_number"] != nil {
                let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :self.contactinfo["phone_number"]! ))
            
                contact.phoneNumbers = [homePhone]
        }
//        let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :self.contactinfo["phone_number"]! ))
//
//        contact.phoneNumbers = [homePhone]
        
        let homeAddress = CNMutablePostalAddress()
        homeAddress.street = "1 Infinite Loop"
        homeAddress.city = "Cupertino"
        homeAddress.state = "CA"
        homeAddress.postalCode = "95014"
        contact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
 
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        try! store.execute(saveRequest)
        
        //if success
        confirmation()
        
    }
    
    private func confirmation() {
        
        print ("entered confirmation")
        let alert = UIAlertController(title:"Success", message:"Do you want to text the person you added?", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        //loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
            print ("continue")
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            print ("cancel")
        }))

   
    }
    
 
    
    func SendMessage(textContent: String, toPerson: String) {
        
        print ("send message called ")
        
        var request = URLRequest(url: NSURL(string: "https://api.catapult.inetwork.com/v1/users/u-2j6eew23n4z4s7wrdzyj5ey/messages")! as URL)
        request.httpMethod = "POST"
        
        let loginData = String(format: "%@:%@", "t-5m2durjfxxj4vh5kbpetega", "ewy4epz24p26ridgegp56yhwfkkgodry2jmgofq").data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
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
    

    
    
    @IBOutlet weak var lbl: UILabel!
   
    
    @IBOutlet weak var textF: UITextField!
    
    var myString=String()
    var contactinfo : [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // move this model somewhere in the new view
        /*
         tested did work
        let messageReceiver = self.contactinfo["phone_number"]
        let message = "this is xxz"
        SendMessage(textContent : message, toPerson : messageReceiver!)
        */
        
        lbl.text = myString
        textF.delegate = self
        textF.isHidden = true
        lbl.isUserInteractionEnabled = true
        let aSelector : Selector = #selector(AddContactViewController.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        lbl.addGestureRecognizer(tapGesture)
        
        addContacts.backgroundColor = .clear
        addContacts.layer.cornerRadius = 14
        addContacts.layer.borderWidth = 4
        addContacts.layer.borderColor = UIColor.white.cgColor
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
