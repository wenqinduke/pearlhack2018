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
//        if myString != ""{
//            contact.givenName = myString
//        }
//        if myString1 != ""{
//            contact.familyName = myString2
//        }
        if textF.isHidden{
            if myString != ""{
                contact.givenName = myString
            }
        }
        else{
            if textF.text != ""{
                contact.givenName = textF.text!
                self.contactinfo["first_name"] = textF.text
            }
        }
        
        if textF1.isHidden{
            if myString1 != ""{
                contact.familyName = myString1
            }
        }
        else{
            if textF1.text != ""{
                contact.familyName = textF1.text!
            }
        }
        
        if textF2.isHidden{
            if myString2 != ""{
                let homie = myString2
                let workEmail = CNLabeledValue(label:CNLabelHome, value: homie as NSString)
                contact.emailAddresses = [workEmail]
            }
        }
        else{
            if textF2.text != ""{
                let homie = textF2.text
                let workEmail = CNLabeledValue(label:CNLabelHome, value: homie! as NSString)
                contact.emailAddresses = [workEmail]
            }
        }
        
        if textF3.isHidden{
            if myString3 != "" {
                let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :myString3 ))
                                contact.phoneNumbers = [homePhone]
            }
        }
        else{
            if textF3.text != "" {
                let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :textF3.text! ))
                contact.phoneNumbers = [homePhone]
                self.contactinfo["phone_number"] = textF3.text
            }
        }
        
        //contact.givenName = self.contactinfo["first_name"]!
        //contact.familyName = self.contactinfo["last_name"]!
        
        contact.jobTitle = "manager"
        
        // check "if x is NSNull()"
//        if myString2 != ""{
//            let homie = myString2
//            let workEmail = CNLabeledValue(label:CNLabelHome, value: homie as NSString)
//            contact.emailAddresses = [workEmail]
//        }
        
        
//        if myString3 != "" {
//                let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :myString3 ))
//                contact.phoneNumbers = [homePhone]
//        }

        
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
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SendMessageView") as! SendMessageViewController
            nextViewController.passedDict=self.contactinfo
            self.present(nextViewController, animated:true, completion:nil)
                
            //print ("continue")
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            print ("cancel")
        }))

   
    }
    
 
    
   
    

    
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var textF: UITextField!
    
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var textF1: UITextField!
    
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var textF2: UITextField!
    
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var textF3: UITextField!
    
    
    var myString = String()
    var myString1=String()
    var myString2=String()
    var myString3=String()
    var contactinfo : [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myString = ""
        if self.contactinfo["first_name"] != nil{
            myString = self.contactinfo["first_name"]!
        }
        
        myString1=""
        
        if self.contactinfo["last_name"] != nil{
            myString1 = self.contactinfo["last_name"]!
        }
        
        myString2="hhh"
        if self.contactinfo["phone_number"] != nil {
            myString2 = self.contactinfo["phone_number"]!
        }
        
        myString3 = ""
        
        if self.contactinfo["email_address"] != nil{
            myString3 = self.contactinfo["email_address"]!
        }
            
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
        lbl.tag = 1
        let aSelector : Selector = #selector(AddContactViewController.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        lbl.addGestureRecognizer(tapGesture)
        
        lbl1.text = myString1
        textF1.delegate = self
        textF1.isHidden = true
        lbl1.isUserInteractionEnabled = true
        lbl1.tag = 2
        let aSelector1 : Selector = #selector(AddContactViewController.lbl1Tapped)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: aSelector1)
        tapGesture1.numberOfTapsRequired = 1
        lbl1.addGestureRecognizer(tapGesture1)
        
        lbl2.text = myString2
        textF2.delegate = self
        textF2.isHidden = true
        lbl2.isUserInteractionEnabled = true
        lbl2.tag = 3
        let aSelector2 : Selector = #selector(AddContactViewController.lbl2Tapped)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: aSelector2)
        tapGesture2.numberOfTapsRequired = 1
        lbl2.addGestureRecognizer(tapGesture2)
        
        lbl3.text = myString3
        textF3.delegate = self
        textF3.isHidden = true
        lbl3.isUserInteractionEnabled = true
        lbl3.tag = 4
        let aSelector3 : Selector = #selector(AddContactViewController.lbl3Tapped)
        let tapGesture3 = UITapGestureRecognizer(target: self, action: aSelector3)
        tapGesture3.numberOfTapsRequired = 1
        lbl3.addGestureRecognizer(tapGesture3)
        
        addContacts.backgroundColor = .clear
        addContacts.layer.cornerRadius = 14
        addContacts.layer.borderWidth = 3
        addContacts.layer.borderColor = UIColor.white.cgColor
        
    }
    
    func lblTapped(){
        lbl.isHidden = true
        textF.isHidden = false
        textF.text = lbl.text
    }
    
    func lbl1Tapped(){
        lbl1.isHidden = true
        textF1.isHidden = false
        textF1.text = lbl1.text
    }
    
    func lbl2Tapped(){
        lbl2.isHidden = true
        textF2.isHidden = false
        textF2.text = lbl2.text
    }
    
    func lbl3Tapped(){
        lbl3.isHidden = true
        textF3.isHidden = false
        textF3.text = lbl3.text
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        if(userText.tag == 1) {
            textF.isHidden = true
            lbl.isHidden = false
            lbl.text = textF.text
        }
        else if(userText.tag == 2) {
            textF1.isHidden = true
            lbl1.isHidden = false
            lbl1.text = textF1.text
        }
        else if(userText.tag == 3) {
            textF2.isHidden = true
            lbl2.isHidden = false
            lbl2.text = textF2.text
        }
        else if(userText.tag == 4) {
            textF3.isHidden = true
            lbl3.isHidden = false
            lbl3.text = textF3.text
        }
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
