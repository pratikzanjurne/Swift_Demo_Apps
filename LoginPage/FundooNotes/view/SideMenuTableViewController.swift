import UIKit

protocol PSideMenuView{
}
protocol PShowNotes{
    func showNotes(_ option: Constant.NoteOfType ,colour:String,viewTitle:String)
}
protocol PHideSideMenu{
    func toggleMenu()
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
    static var showNotesDelegate:PShowNotes?
    static var sideMenuDelegate:PHideSideMenu?
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
        switch indexPath.section{
            case 0:
                SideMenuTableViewController.sideMenuDelegate?.toggleMenu()
                SideMenuTableViewController.showNotesDelegate?.showNotes(.note, colour: Constant.Color.colourOrange, viewTitle: Constant.DashboardViewTitle.noteView)
                break;
            case 1:
               SideMenuTableViewController.sideMenuDelegate?.toggleMenu()
               SideMenuTableViewController.showNotesDelegate?.showNotes(.archive, colour: Constant.Color.colourForFilterOn, viewTitle: Constant.DashboardViewTitle.archivedView)
                break;
            case 2:
                SideMenuTableViewController.sideMenuDelegate?.toggleMenu()
                SideMenuTableViewController.showNotesDelegate?.showNotes(.deleted, colour: Constant.Color.colourForFilterOn, viewTitle: Constant.DashboardViewTitle.deletedView)
                break;
            case 3:
               SideMenuTableViewController.sideMenuDelegate?.toggleMenu()
               SideMenuTableViewController.showNotesDelegate?.showNotes(.reminder, colour: Constant.Color.colourForFilterOn, viewTitle: Constant.DashboardViewTitle.reminderView)
                break;
            case 4:
                SideMenuTableViewController.sideMenuDelegate?.toggleMenu()
                SideMenuTableViewController.sideMenuDelegate?.showSignOutAlert()
                break;
            default:
                break
        }
    }
}
