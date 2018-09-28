import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FirebaseDBManager{
    
    static let shared = FirebaseDBManager()
    private let rootRef = Database.database().reference().child("users")
    private let storageRootRef = Storage.storage().reference()
    private init(){
    }
    
    func createUser(userModel:UserModel,completion:@escaping (Bool)->Void){
        Auth.auth().createUser(withEmail: userModel.emailId, password: userModel.password) { (authResult, error) in
            if error == nil {
                guard let user = authResult?.user else{
                    completion(false)
                    return
                }
                let userRef = self.rootRef.child(user.uid)
                let userInfoRef = userRef.child("user_info")
                let userInfo = ["username":userModel.username,"lastname":userModel.lastname,"email":userModel.emailId,"password":userModel.password,"mobile_no":userModel.mobileNo]
                userInfoRef.setValue(userInfo)
                completion(true)
            }
        }
    }
    
    func loginUser(email:String,password:String,completion:@escaping (Bool,String)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error == nil{
                if let user = authResult?.user{
                    self.getCurrentUserInfo(userId: user.uid, completion: { (userInfo) in
                        UserDefaults.standard.set(userInfo.email, forKey: "userId")
                        UserDefaults.standard.set(userInfo.username, forKey: "username")
                        completion(true, "User found")
                    })
                }else{
                    completion(false, "User not Found")
                }
            }else{
                completion(false, (error?.localizedDescription)!)
            }
        }
    }
    
    func getCurrentUserInfo(userId:String,completion:@escaping (UserInfoModel)->Void){
        let userRef = self.rootRef.child(userId)
        let userInfoRef = userRef.child("user_info")
        userInfoRef.observe(DataEventType.value, with: {(snapshot) in
            if let userInfo = snapshot.value as? [String:Any]{
                guard let firstname = userInfo["username"] as? String else { return }
                guard let lastname = userInfo["lastname"] as? String else { return }
                guard let email = userInfo["email"] as? String else {
                    return
                }
                let username = "\(firstname) \(lastname)"
                let userInfoModel = UserInfoModel(username: username, email: email)
                completion(userInfoModel)
            }
        })
    }
    
    func saveNote(note:NoteModel){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userNotesRef = self.rootRef.child(userId).child("notes")
        let noteRef = userNotesRef.child(note.note_id)
        if let imageData = note.image as Data?{
            let stringUID = NSUUID().uuidString
            let imageRef = storageRootRef.child("noteImages").child("\(stringUID).png")
            imageRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                        return
                    }
                    if let imageURL = url?.absoluteString{
                        let noteInfo:[String:Any] = ["title":note.title,"note":note.note,"creadtedDate":note.creadted_date,"reminderDate":"\(note.reminder_date!) \(note.reminder_time!)","editedDate":note.edited_date,"isArchived":note.is_archived,"isDeleted":note.is_deleted,"isPinned":note.is_pinned,"isRemindered":note.is_remidered,"color":note.colour,"image":imageURL]
                        noteRef.setValue(noteInfo)
                        
                    }
                })
            })
        }else{
            let noteInfo:[String:Any] = ["title":note.title,"note":note.note,"creadtedDate":note.creadted_date,"reminderDate":"\(note.reminder_date!) \(note.reminder_time!)","editedDate":note.edited_date,"isArchived":note.is_archived,"isDeleted":note.is_deleted,"isPinned":note.is_pinned,"isRemindered":note.is_remidered,"color":note.colour]
            noteRef.setValue(noteInfo)
        }
    }
    
    func deleteNote(noteToDelete:NoteModel,completion:(Bool,String)->Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userNotesRef = self.rootRef.child(userId).child("notes")
        let noteRef = userNotesRef.child(noteToDelete.note_id)
        let value = ["isDeleted":true]
        noteRef.updateChildValues(value)
        completion(true, "Deleted")
    }
    
    
}
