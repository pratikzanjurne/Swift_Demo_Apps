import UIKit

protocol PDashboardContainerView {
    func showView(view:String)
}

class DashboardContainerViewController: BaseViewController,PDashboardContainerView {
    
    var name:String = ""
    @IBOutlet var sideMenuConstrains: NSLayoutConstraint!

    var isOpenedSideMenu = false
    var data:((_ note:User)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialseView()
    }
    
    override func initialseView() {
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginViewController), name: NSNotification.Name("ShowLoginView"), object: nil)

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
    @objc func showLoginViewController(){
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    func showView(view:String){
        let vc = storyboard?.instantiateViewController(withIdentifier: view) as! TakeNoteViewController
        let vc1 = UINavigationController(rootViewController: vc)
        self.navigationController?.pushViewController(vc1, animated: true)
    }
}


