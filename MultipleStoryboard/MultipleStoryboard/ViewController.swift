//
//  ViewController.swift
//  MultipleStoryboard
//
//  Created by BridgeLabz Solutions LLP  on 8/10/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func but(_ sender: Any) {
        var storyboard = UIStoryboard(name: "StoryboardNew", bundle: nil)
        var controller = storyboard.instantiateViewController(withIdentifier: "identifier") as UIViewController
        self.present(controller, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

