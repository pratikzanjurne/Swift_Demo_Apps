import Foundation

class LoginViewPresenter{
    var pLoginView:PLoginView?
    let presenterService:PresenterService
    
    init(pLoginView:PLoginView,presenterService:PresenterService) {
        self.pLoginView = pLoginView
        self.presenterService = presenterService
    }
    
    func loginUser(email:String,password:String){
        if presenterService.validateEmailPattern(email: email){
            presenterService.loginUser(email: email, password: password) { (response, message, user) in
                if response{
                    UserDefaults.standard.set(user?.email, forKey: "userId")
                    let firstName = user?.username
                    let lastName = user?.lastname
                    UserDefaults.standard.set("\(firstName!) \(lastName!)", forKey: "username")
                    pLoginView?.showDashboardViewController()
                }else{
                    pLoginView?.showAlert(message: message)
                }
            }
        }else {
    self.pLoginView?.showAlert(message: "Enter the valid email address.")
        }
    }
    
    func loginWithFacebook(email:String,username:String,imageUrl:String?){
                UserDefaults.standard.set(email, forKey: "userId")
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(imageUrl, forKey: "imageUrl")
                pLoginView?.showDashboardViewController()
    }
}
