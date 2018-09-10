//
//  SecondViewController.swift
//  TransferData
//
//  Created by BridgeLabz Solutions LLP  on 8/10/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var sliderValue: UISlider!
    @IBOutlet var viewSeg: UIView!
    var name:String = ""
    @IBOutlet var lableName: UILabel!
    @IBOutlet var section: UISegmentedControl!
    override func viewDidLoad() {
        lableName.text = "Hello"
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sliderAction(_ sender: Any) {
        let currentValue = Int(sliderValue.value*100)
        print(currentValue)
        if currentValue<25{
            viewSeg.backgroundColor = UIColor.blue
        }else if 26<currentValue&&currentValue<70{
            viewSeg.backgroundColor = UIColor.brown
        }else{
            viewSeg.backgroundColor = UIColor.orange
        }
    }
    
    @IBAction func actionPerformed(_ sender: Any) {
        let index = section.selectedSegmentIndex
        switch index {
        case 0:
            lableName.text = "Hello"
        case 1:
            lableName.text = name
        default:
            lableName.text = "Hello"

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
