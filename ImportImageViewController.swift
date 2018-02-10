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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image=info[UIImagePickerControllerOriginalImage] as? UIImage{
           NamecardImage.image=image
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
        scanCamera.layer.borderWidth = 5
        scanCamera.layer.borderColor = UIColor.white.cgColor
        photoLibrary.backgroundColor = .clear
        photoLibrary.layer.cornerRadius = 20
        photoLibrary.layer.borderWidth = 5
        photoLibrary.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func detectInfo(_ sender: Any) {
        print ("testing")
        requesting(img: nameCard)
        
        
        
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
        //let image = UIImage(named: "card.jpeg")!
        //let imageData  = UIImageJPEGRepresentation(image, 1.0)!
        
        let imageData  = UIImageJPEGRepresentation(img, 1.0)!

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
                self.passInfo=lan
                print(lan)
                
            } catch let error as NSError {
                print(error)
            }
            
            }.resume()
        
        
    }
    
    @IBAction func confirm(_ sender: Any) {
        performSegue(withIdentifier: "confirmContact", sender: self)
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
