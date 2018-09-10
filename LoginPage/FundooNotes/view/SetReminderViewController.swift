import UIKit

class SetReminderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableViewOptions: UITableView!
    var array = ["Date","Time","Repeat"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOptions.dataSource = self
        tableViewOptions.delegate = self
    }


    @IBAction func onCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        cell.subTitleLbl.text = array[indexPath.section]
        return cell
    }
}

