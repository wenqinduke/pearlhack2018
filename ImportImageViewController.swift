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
    var infodict : [String: String] = [:]
    
    
    

    
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
                
                
               
                
              
                var alltext = [String]()
                
                for i in (json["regions"] as? [[String: Any]])! {
                    for j in (i["lines"] as? [[String: Any]])!{
                        for k in (j["words"] as? [[String: Any]])!{
                            let currentline = k["text"]!
                            //print(currentline)
                            alltext.append(currentline as! String)
                        }
                    }
                }
                
                
                self.infodict["first_name"] = alltext[0]
                self.infodict["last_name"] = alltext[1]
                
                
                
                
                for i in alltext{
                    print(i)
                    if(self.checkNumber(str: i)){
                        let matched = self.matches(for: "[0-9]", in: i)
                        var temp : String = ""
                        for m in matched{
                            temp += m
                        }
                        self.infodict["phone number"] = temp
                    }
                    if(self.checkEmail(str: i)){
                       self.infodict["email address"] = i
                    }
                }
                
                

                
                    

                //transfer to next page
                DispatchQueue.main.async{
                self.performSegue(withIdentifier: "confirmContact", sender: self)
                }
                
                
            } catch let error as NSError {
                print(error)
            }
            
            }.resume()
        
        
    }
    
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func checkNumber(str: String) -> Bool{
        let matched = matches(for: "[0-9]", in: str)
        if (matched.count > 9){
            return true
        }else{
            return false
        }
    }
    
    func checkEmail(str: String) -> Bool{
        let matched = matches(for: "@", in: str)
        if (matched.count > 0){
            return true
        }else{
            return false
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "confirmContact" as NSString:
            
            let secondController=segue.destination as! AddContactViewController
           
                secondController.myString=self.passInfo
                secondController.contactinfo = self.infodict
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
