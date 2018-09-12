import UIKit
import MaterialControls

protocol PSetReminderView{
    func openPopUpView(_ option : Helper.reminderOptionSelected)
}

class SetReminderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,PSetReminderView {
    
    
    @IBOutlet var tableViewOptions: UITableView!
    var presenter:SetReminderPresenter?
    var array = ["Date","Time","Repeat"]
    var subTitleArray = ["MMM d, yyyy","HH:MM","Repeat"]
    var selectedSection:Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SetReminderPresenter(pSetReminderView: self)
        tableViewOptions.dataSource = self
        tableViewOptions.delegate = self
    }


    @IBAction func onCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDonePressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TakeNoteViewController") as! TakeNoteViewController
        self.dismiss(animated: true) {
            vc.reminderArray.append("efresfe")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetReminderCell", for: indexPath) as! SetReminderTableViewCell
        cell.titleLabel.text = array[indexPath.section]
        cell.subTitleLbl.text = subTitleArray[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSection = indexPath.section
        switch indexPath.section {
        case 0:
            presenter?.openPopUpView(.date)
            break
        case 1:
            presenter?.openPopUpView(.time)
            break
        case 2:
            presenter?.openPopUpView(.repeate)
            break
        default:
            break
        }
    }
    
    func openPopUpView(_ option: Helper.reminderOptionSelected) {
        switch option {
        case .date:
            let datePickerDialog = MDDatePickerDialog()
            datePickerDialog.delegate = self
            datePickerDialog.show()
            break
        case .time:
            let timePickerDialog = MDTimePickerDialog()
            timePickerDialog.delegate = self
            timePickerDialog.show()
            break
            
        case .repeate:
            break
        default:
            break
        }
    }

}

extension SetReminderViewController:MDDatePickerDialogDelegate,MDTimePickerDialogDelegate{
    func timePickerDialog(_ timePickerDialog: MDTimePickerDialog, didSelectHour hour: Int, andMinute minute: Int) {
        self.subTitleArray[selectedSection] = "\(hour):\(minute)"
        self.tableViewOptions.reloadData()
    }
    
    func datePickerDialogDidSelect(_ date: Date) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM d, yyyy"
        let dateInFormat = dateFormater.string(from: date)
        self.subTitleArray[selectedSection] = "\(dateInFormat)"
        self.tableViewOptions.reloadData()
    }
    

}

