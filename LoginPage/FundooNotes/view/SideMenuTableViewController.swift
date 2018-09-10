import UIKit

protocol PSideMenuView{
    func showSignOutAlert()
}

class SideMenuTableViewController: UITableViewController,PSideMenuView {


    @IBOutlet var userEmailLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var notesCell: UITableViewCell!
    @IBOutlet var archiveCell: UITableViewCell!
    @IBOutlet var deletedCell: UITableViewCell!
    @IBOutlet var remainderCell: UITableViewCell!
    @IBOutlet var signOutCell: UITableViewCell!
     let menu = ["Notes","Archive","Deleted","Sign Out",""]
    var presenter:SideMenuPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseView()
    }
    func initialiseView(){
        presenter = SideMenuPresenter(pSideMenuView: self, persenterService: DashboardPresenterService())
        notesCell.textLabel?.text = "Notes"
        archiveCell.textLabel?.text = "Archieve"
        deletedCell.textLabel?.text = "Deleted"
        remainderCell.textLabel?.text = "Remainder"
        signOutCell.textLabel?.text = "Sign Out"
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4{
            presenter?.showSignOutAlert()
        }
    }
    
    
    func showSignOutAlert() {
        let alert = UIAlertController(title: "Do you want to sign out",
                                      message:nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Sign Out", style: .default) { (_) in
            UserDefaults.standard.set(nil, forKey: "userId")
            UIHelper.shared.postNotification(Name: "ShowLoginView")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
}
