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

    @IBAction func SelectImage(_ sender: Any) {
        
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
