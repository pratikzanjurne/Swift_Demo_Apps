
import UIKit
import  CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    var people = [Person]()
    func numberOfSections(in tableView: UITableView) -> Int {
        return people.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = people[indexPath.section].name
        cell.detailTextLabel?.text = String(people[indexPath.section].age)
        cell.layer.backgroundColor = UIColor.brown.cgColor
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 10
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            let fetchRequest:NSFetchRequest<Person> = Person.fetchRequest()
            let people = try PersistanceService.context.fetch(fetchRequest)
            self.people = people
            self.tableview.reloadData()
        }catch{
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPlus(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Age"
            textField.keyboardType = .numberPad
        }
        let action = UIAlertAction(title: "Post", style: .default) { (_) in
            let name = alert.textFields?.first?.text
            let Age = alert.textFields?.last?.text
            let person = Person(context: PersistanceService.context)
            person.name = name
            person.age = Int16(Age!)!
            PersistanceService.saveContext()
            self.people.append(person)
            self.tableview.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
