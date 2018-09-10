//
//  ViewController.swift
//  DefaultUser
//
//  Created by BridgeLabz Solutions LLP  on 8/13/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var labelText: UILabel!
    var number:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        labelText.text = "\(UserDefaults.standard.integer(forKey: "number"))"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func tap(_ sender: Any) {
        if Int(labelText.text!)!>number{
            number = Int(labelText.text!)!
            number = number + 1
            UserDefaults.standard.set(number, forKey: "number")
            labelText.text = "\(UserDefaults.standard.integer(forKey: "number"))"
        }else{
            number = number + 1
            UserDefaults.standard.set(number, forKey: "number")
            labelText.text = "\(UserDefaults.standard.integer(forKey: "number"))"
        }
        
    }
    
    
    @IBAction func reset(_ sender: Any) {
        number = 0
        labelText.text = "\(number)"
    }
}

