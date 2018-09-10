import UIKit

class UserTableViewController: UITableViewController {
    
    let presenter:PresenterProtocol = Presenter()
    var users = [User]()
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        users = presenter.loadUsers()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else{
            fatalError("Cant load table view")
        }
        
        let userInfo = users[i]
        i += 1
        cell.name.text =  userInfo.name
        cell.lastName.text = userInfo.lastName
        cell.photo.image = userInfo.photo
        return cell
    }
    

}
