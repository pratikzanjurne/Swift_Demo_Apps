import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FirebaseDBManager{
    
    static let shared = FirebaseDBManager()
    private let rootRef = Database.database().reference().child("users")
    private init(){
    }
    
    func createUser(userModel:UserModel,completion:@escaping (Bool)->Void){
        Auth.auth().createUser(withEmail: userModel.emailId, password: userModel.password) { (authResult, error) in
            if error == nil {
                guard let user = authResult?.user else{ return }
                let userRef = self.rootRef.child(user.uid)
                let userInfoRef = userRef.child("user_info")
                let userInfo = ["username":userModel.username,"lastname":userModel.lastname,"email":userModel.emailId,"password":userModel.password,"mobile_no":userModel.mobileNo]
                userInfoRef.setValue(userInfo)
                completion(true)
            }
        }
    }
    
    
}
