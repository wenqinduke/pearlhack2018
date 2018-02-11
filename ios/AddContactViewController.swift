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
    
    @IBAction func Addcontact(_ sender: Any) {
        let contact = CNMutableContact()
        //contact.imageData = NSData() // The profile picture as a NSData object
        print ("here")
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
        
        
        let alert = UIAlertController(title: nil, message: "You have successfully add the contact!", preferredStyle: .alert)
        
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
    
    func SendMessage(textContent: String, toPerson: String) {
        
        print ("send message called ")
        
        var request = URLRequest(url: NSURL(string: "https://api.catapult.inetwork.com/v1/users/u-2j6eew23n4z4s7wrdzyj5ey/messages")! as URL)
        request.httpMethod = "POST"
        
        let loginData = String(format: "%@:%@", "t-5m2durjfxxj4vh5kbpetega", "ewy4epz24p26ridgegp56yhwfkkgodry2jmgofq").data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let body = ["to" : "+19198138625",  // change here
            "from" : "+19842198388",
            "text" : "Yiqin Zhou" // change to textContent here
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
        
        
    }
    

    
    
    @IBOutlet weak var contactInfo: UILabel!
    var myString=String()
    var contactinfo : [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactInfo.text = myString

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
