//
//  AddContactViewController.swift
//  ios
//
//  Created by Wenqin Wang on 2/10/18.
//  Copyright © 2018 Yiqin Zhou. All rights reserved.
//

import UIKit
import Contacts

class AddContactViewController: UIViewController {
    
    @IBOutlet weak var addContacts: UIButton!
    
    @IBAction func Addcontact(_ sender: Any) {
        let contact = CNMutableContact()
        //contact.imageData = NSData() // The profile picture as a NSData object
        contact.givenName = "John"
        contact.familyName = "Appleseed"
        
        contact.jobTitle = "manager"
        
        let homie = "john@example.com"
        let workie = "j.appleseed@icloud.com"
        let homeEmail = CNLabeledValue(label:CNLabelHome, value: homie as NSString)
        let workEmail = CNLabeledValue(label:CNLabelWork, value:workie as NSString)
        contact.emailAddresses = [homeEmail, workEmail]
        
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
        
        
        let alert = UIAlertController(title:"Success", message:"Do you want to text the person you added?", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        //loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            NSLog("OK Pressed")
//        }
//        alert.addAction(okAction)
        

        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
            print ("continue")
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            print ("cancel")
        }))

    }

    
    
    @IBOutlet weak var contactInfo: UILabel!
    var myString=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactInfo.text = myString
        
        addContacts.backgroundColor = .clear
        addContacts.layer.cornerRadius = 14
        addContacts.layer.borderWidth = 4
        addContacts.layer.borderColor = UIColor.white.cgColor


        // Do any additional setup after loading the view.
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
