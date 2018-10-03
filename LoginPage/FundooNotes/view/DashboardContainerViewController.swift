import UIKit

protocol PDashboardContainerView {

}

class DashboardContainerViewController: BaseViewController,PDashboardContainerView,PHideSideMenu {
    
    var name:String = ""
    var isNotificationTriggered = false
    var notificationNoteId = ""
    @IBOutlet var sideMenuConstrains: NSLayoutConstraint!

    var isOpenedSideMenu = false
    var userId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialseView()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNotificationTriggered{
            isNotificationTriggered = false
            let stroryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = stroryBoard.instantiateViewController(withIdentifier: "TakeNoteViewController") as! TakeNoteViewController
            present(vc, animated: true, completion: nil)
        }
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
            UserDefaults.standard.set(nil, forKey: "username")
            self.showLoginViewController()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


