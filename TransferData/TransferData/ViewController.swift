import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    // MARK: - Declaration
    var text:String = ""
    @IBOutlet var textData: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textData.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonAction(_ sender: Any) {
        self.text = textData.text!
        perform
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SecondViewController
        vc.name = text
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.text = textData.text!
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textData.resignFirstResponder()
        return true
    }
}

