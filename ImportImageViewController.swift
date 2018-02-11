//
//  ImportImageViewController.swift
//  ios
//
//  Created by ZhouYiqin on 2/9/18.
//  Copyright © 2018 Yiqin Zhou. All rights reserved.
//

import UIKit

class ImportImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var image: UIImagePickerController!
    var nameCard: UIImage!
    var passInfo: String!
    

    
    @IBOutlet weak var scanCamera: UIButton!

    @IBOutlet weak var photoLibrary: UIButton!
    
    @IBAction func SelectImage(_ sender: Any) {
        print("test for button")
        image = UIImagePickerController()
        image.delegate=self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing=false
        self.present(image,animated:true){
        
        }
    }
    @IBOutlet weak var NamecardImage: UIImageView!
    
    @IBAction func ScanImage(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            
            let image = UIImagePickerController()
            image.delegate=self
            image.sourceType = UIImagePickerControllerSourceType.camera
            image.allowsEditing=false
            self.present(image,animated:true){
                
            }

        }
        
        
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image=info[UIImagePickerControllerOriginalImage] as? UIImage{
           NamecardImage.image=image
           NamecardImage.contentMode = UIViewContentMode.scaleAspectFit
           nameCard=image
        }
        else{
            //error message
        
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func SendMessage(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanCamera.backgroundColor = .clear
        scanCamera.layer.cornerRadius = 20
        scanCamera.layer.borderWidth = 4
        scanCamera.layer.borderColor = UIColor.white.cgColor
        photoLibrary.backgroundColor = .clear
        photoLibrary.layer.cornerRadius = 20
        photoLibrary.layer.borderWidth = 4
        photoLibrary.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadCustomViewIntoController() {
       
        
        let alert = UIAlertController(title: nil, message: "Please add a namecard", preferredStyle: .alert)
        
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
    
    
    //confirm action
    @IBAction func detectInfo(_ sender: Any) {

        print ("testing")
        if let image=nameCard as? UIImage{
            requesting(img: nameCard)
        }
        else{
            print ("success")
            loadCustomViewIntoController()
        }

        
    }
    
    
    func requesting(img: UIImage) {
        let key =  " bea5456245a14ae6b0486d13adda1e71"
        
        var request = URLRequest(url: NSURL(string: "https://westcentralus.api.cognitive.microsoft.com/vision/v1.0/ocr?language=unk&detectOrientation=true")! as URL)
        
        request.httpMethod = "POST"
        request.addValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        
        
        /*
         
         // this is send a image from url
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         let body = ["url": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Broadway_and_Times_Square_by_night.jpg/450px-Broadway_and_Times_Square_by_night.jpg"]
         do{
         request.httpBody = try JSONSerialization.data(withJSONObject: body)
         } catch{
         print("error in try")
         }
         */
        
        // send a local image
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        //testing local image
        let image = UIImage(named: "card.jpeg")!
        let imageData  = UIImageJPEGRepresentation(image, 1.0)!
        
        //let imageData  = UIImageJPEGRepresentation(img, 1.0)!
        
        request.httpBody = imageData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("did not get data")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                
                
                // here you can parse all json file
                // print out language filed as an example
                
                let lan = json["language"] as? String
                print ("++++++++++++++++++")
                print(lan!)
                self.passInfo = lan!
                
                
               // print(json["regions"] as? String!)
                
                /*
                 
                 example
                let blogs = json["blogs"] as? [[String: Any]] {
                    for blog in blogs {
                        if let name = blog["name"] as? String {
                            names.append(name)
                        }
                    }
                }
                 */
                
                //TODO: need to debug this
                
                /*
                for i in json["regions"] {
                    for j in i["lines"]{
                        for k in j["words"]{
                            print(k["text"])
                        }
                    }
                }
 */
                    

                //transfer to next page
                DispatchQueue.main.async{
                self.performSegue(withIdentifier: "confirmContact", sender: self)
                }
                
                
            } catch let error as NSError {
                print(error)
            }
            
            }.resume()
        
        
    }
    
    
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "confirmContact" as NSString:
            
            let secondController=segue.destination as! AddContactViewController
           
                secondController.myString=self.passInfo
        //secondController.myString="hhh"
        default:
            print ("" as NSString)
            
            
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

}
