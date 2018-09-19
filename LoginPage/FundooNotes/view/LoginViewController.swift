import UIKit
import CoreData
import FBSDKLoginKit

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
        
        facebookBtn.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardContainerViewController") as! DashboardContainerViewController
        present(vc, animated: true) {
            
        }
    }
    
    @objc func loginButtonClicked() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (loginresult, error) in
            if error == nil{
                let result:FBSDKLoginManagerLoginResult = loginresult!
                if result.isCancelled{
                    print("Cancled")
                    loginManager.logOut()
                }else if result.grantedPermissions.contains("email"){
                    self.returnUserData()
                    loginManager.logOut()
                    print("LoggedIn")
                }
            }
        }
    }
    func returnUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
//                    if let result = result as? [String:Any]{
//                        result.valueForKey("email") as! String
//                        result.valueForKey("id") as! String
//                        result.valueForKey("name") as! String
//                        result.valueForKey("first_name") as! String
//                        result.valueForKey("last_name") as! String
//                    }
                }
            })
        }
    }
}


