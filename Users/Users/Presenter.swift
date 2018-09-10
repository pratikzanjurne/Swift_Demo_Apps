import Foundation
import UIKit

protocol PresenterProtocol {
    func loadUsers()->[User]
}

class Presenter:PresenterProtocol{
    
    internal func loadUsers()->[User]{
         var users = [User]()
        
        let photo1 = UIImage(named: "user")
        let user1 = User(name: "Pratik", lastName: "Zanjurne", photo: photo1)
        let user2 = User(name: "Prasad", lastName: "Zanjurne", photo: photo1)
        let user3 = User(name: "Amit", lastName: "Ghorpade", photo: photo1)
        let user4 = User(name: "Mohit", lastName: "Ghorpade", photo: photo1)
        let user5 = User(name: "Sagar", lastName: "Ghorpade", photo: photo1)
        let user6 = User(name: "Akshay", lastName: "Ghorpade", photo: photo1)
        let user7 = User(name: "Ashish", lastName: "Gharge", photo: photo1)
        users += [user1,user2,user3,user4,user5,user6,user7]
        
        return users
    }
}
