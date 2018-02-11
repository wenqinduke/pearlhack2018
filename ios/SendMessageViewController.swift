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
    
    
    var myStringx=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myStringx="hhh"
        
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
