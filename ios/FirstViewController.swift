//
//  FirstViewController.swift
//  ios
//
//  Created by ZhouYiqin on 2/9/18.
//  Copyright © 2018 Yiqin Zhou. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addBackground(imageName: "back.jpeg", contextMode: .scaleAspectFit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

