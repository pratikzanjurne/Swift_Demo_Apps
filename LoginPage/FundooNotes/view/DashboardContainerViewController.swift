import UIKit

protocol PDashboardContainerView {

}

class DashboardContainerViewController: BaseViewController,PDashboardContainerView,PHideSideMenu {
    
    var name:String = ""
    @IBOutlet var sideMenuConstrains: NSLayoutConstraint!

    var isOpenedSideMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialseView()
    }
    
    override func initialseView() {
        SideMenuTableViewController.sideMenuDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }

    @objc func toggleSideMenu(){
        if isOpenedSideMenu{
            self.sideMenuConstrains.constant = -240
            UIView.animate(withDuration: 0.8){
                self.view.layoutIfNeeded()
            }
            self.isOpenedSideMenu = false
        }else{
            self.sideMenuConstrains.constant = 0
            UIView.animate(withDuration:0.8){
                self.view.layoutIfNeeded()
            }
            self.isOpenedSideMenu = true
        }
    }
    func showLoginViewController(){
        performSegue(withIdentifier: "logout", sender: self)
    }
    func toggleMenu(){
        if isOpenedSideMenu{
            self.sideMenuConstrains.constant = -240
            UIView.animate(withDuration: 0.8){
                self.view.layoutIfNeeded()
            }
            self.isOpenedSideMenu = false
        }else{
            self.sideMenuConstrains.constant = 0
            UIView.animate(withDuration:0.8){
                self.view.layoutIfNeeded()
            }
            self.isOpenedSideMenu = true
        }
    }
    func showSignOutAlert() {
        let alert = UIAlertController(title: "Do you want to sign out",
                                      message:nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Sign Out", style: .default) { (_) in
            UserDefaults.standard.set(nil, forKey: "userId")
            self.showLoginViewController()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


