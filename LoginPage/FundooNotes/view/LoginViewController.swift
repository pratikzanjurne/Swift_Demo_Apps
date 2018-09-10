import UIKit
import CoreData

protocol PLoginView{
    func showAlert(message:String)
    func showDashboardViewController()
}


class LoginViewController:BaseViewController,PLoginView {

    private var presenter:LoginViewPresenter?
    
    @IBOutlet var googleBtn: UIButton!
    @IBOutlet var facebookBtn: UIButton!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var createAccBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var usernameID: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        initialseView()
        
    }
    
    override func initialseView() {
        presenter = LoginViewPresenter(pLoginView: self, presenterService: PresenterService())
        if UserDefaults.standard.object(forKey: "userId") != nil{
            showDashboardViewController()
        }else{
            
        }
        facebookBtn.layer.borderColor = UIColor.blue.cgColor
        facebookBtn.layer.borderWidth = 2
        facebookBtn.layer.cornerRadius = 15
        googleBtn.layer.borderColor = UIColor.orange.cgColor
        googleBtn.layer.borderWidth = 2
        googleBtn.layer.cornerRadius = 15
        createAccBtn.layer.cornerRadius = 15
        loginBtn.layer.cornerRadius = 15
    }
    @IBAction func loginAction(_ sender: Any) {
        if (usernameID.text?.isEmpty)! && (passwordText.text?.isEmpty)!{
            showAlert(message: "Enter email and password.")
        }else{
            presenter?.loginUser(email: usernameID.text!, password: passwordText.text!)
        }
    }
 
    @IBAction func forgotPassword(_ sender: Any) {
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Can't Login", message: message , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
           alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showDashboardViewController() {
    }
}


