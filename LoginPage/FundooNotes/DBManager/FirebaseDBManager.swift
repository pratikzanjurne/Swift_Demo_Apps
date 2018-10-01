import Foundation
import Firebase
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

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
                    print(error?.localizedDescription as Any)
                    return
                }
                
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error?.localizedDescription as Any)
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
    
    func deleteNote(noteToDelete:NoteModel,completion:@escaping (Bool,String)->Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userNotesRef = self.rootRef.child(userId).child("notes")
        userNotesRef.observe(.value) { (snapshot) in
            if snapshot.hasChild(noteToDelete.note_id){
                let noteRef = userNotesRef.child(noteToDelete.note_id)
                let value = ["isDeleted":true]
                noteRef.updateChildValues(value)
                completion(true,"Deleted")
                return
            }else{
                completion(false, "Note not found")
            }
        }
    }
    
    func deleteNoteFromTrash(noteToDelete:NoteModel,completion:@escaping (Bool,String)->Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userNoteRef = rootRef.child(userId).child("notes")
        userNoteRef.observe(.value) { (snapshot) in
            if snapshot.hasChild(noteToDelete.note_id){
                let noteRef = userNoteRef.child(noteToDelete.note_id)
                noteRef.removeValue()
                completion(true,"Deleted")
                return
            }else{
                completion(false, "Note note found")
            }
        }
    }
    
    func restoreNoteFromTrash(noteToRestore:NoteModel,completion:@escaping (Bool,String)->Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userNotesRef = self.rootRef.child(userId).child("notes")
        userNotesRef.observe(.value) { (snapshot) in
            if snapshot.hasChild(noteToRestore.note_id){
                let noteRef = userNotesRef.child(noteToRestore.note_id)
                let value = ["isDeleted":false]
                noteRef.updateChildValues(value)
                completion(true,"Restored")
                return
            }else{
                completion(false, "Note not found")
            }
        }
    }
    
    func pinNote(noteToPin:NoteModel,completion:@escaping (Bool,String)->Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userNotesRef = self.rootRef.child(userId).child("notes")
        userNotesRef.observe(.value) { (snapshot) in
            if snapshot.hasChild(noteToPin.note_id){
                let noteRef = userNotesRef.child(noteToPin.note_id)
                let value = ["isPinned":true,"isArchived":false]
                noteRef.updateChildValues(value)
                completion(true,"Restored")
                return
            }else{
                completion(false, "Note not found")
            }
        }
    }
    
    func pinNoteArray(notes:[NoteModel],completion:@escaping (Bool,String)->Void){
        for note in notes{
            self.pinNote(noteToPin: note, completion: { (result,message) in
                completion(result, message)
            })
        }
    }
    
    func getNotes(completion:@escaping ([NoteModel])->Void){
        var notes = [NoteModel]()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userNotesRef = rootRef.child(userId).child("notes")
        userNotesRef.observe(.value) { (snapshot) in
            guard let noteObjects  = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for noteObject in noteObjects{
                guard let note = noteObject.value as? [String:Any] else { return }
                let noteId = noteObject.key
                let color = note["color"] as! String
                let createdDate = note["creadtedDate"] as! String
                let editedDate = note["editedDate"] as! String
                let isArchived = note["isArchived"] as! Bool
                let isDeleted = note["isDeleted"] as! Bool
                let isPinned = note["isPinned"] as! Bool
                let isRemindered = note["isRemindered"] as! Bool
                let noteDisc = note["note"] as! String
                let reminderDate = note["reminderDate"] as! String
                let title = note["title"] as! String
                if isDeleted == false{
                    if let noteImageURL = note["image"] as? String{
                        
                        notes.append(NoteModel(title: title, note: noteDisc, image: nil, is_archived: isArchived, is_remidered: isRemindered, is_deleted: isDeleted, creadted_date: createdDate, colour: color, note_id: noteId, is_pinned: isPinned, reminder_date: reminderDate, reminder_time: reminderDate, userId: userId, edited_date: editedDate, imageUrl: noteImageURL))
                    }else{
                        notes.append(NoteModel(title: title, note: noteDisc, image: nil, is_archived: isArchived, is_remidered: isRemindered, is_deleted: isDeleted, creadted_date: createdDate, colour: color, note_id: noteId, is_pinned: isPinned, reminder_date: reminderDate, reminder_time: reminderDate, userId: userId, edited_date: editedDate, imageUrl: nil))
                    }
                }
            }
            completion(notes)
        }
    }
    
    func getDeletedNotes(completion:@escaping ([NoteModel])->Void){
        var notes = [NoteModel]()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userNotesRef = rootRef.child(userId).child("notes")
        userNotesRef.observe(.value) { (snapshot) in
            guard let noteObjects  = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for noteObject in noteObjects{
                guard let note = noteObject.value as? [String:Any] else { return }
                let noteId = noteObject.key
                let color = note["color"] as! String
                let createdDate = note["creadtedDate"] as! String
                let editedDate = note["editedDate"] as! String
                let isArchived = note["isArchived"] as! Bool
                let isDeleted = note["isDeleted"] as! Bool
                let isPinned = note["isPinned"] as! Bool
                let isRemindered = note["isRemindered"] as! Bool
                let noteDisc = note["note"] as! String
                let reminderDate = note["reminderDate"] as! String
                let title = note["title"] as! String
                if isDeleted{
                    if let noteImageURL = note["image"] as? String{
                        notes.append(NoteModel(title: title, note: noteDisc, image: nil, is_archived: isArchived, is_remidered: isRemindered, is_deleted: isDeleted, creadted_date: createdDate, colour: color, note_id: noteId, is_pinned: isPinned, reminder_date: reminderDate, reminder_time: reminderDate, userId: userId, edited_date: editedDate, imageUrl: noteImageURL))
                    }else{
                        notes.append(NoteModel(title: title, note: noteDisc, image: nil, is_archived: isArchived, is_remidered: isRemindered, is_deleted: isDeleted, creadted_date: createdDate, colour: color, note_id: noteId, is_pinned: isPinned, reminder_date: reminderDate, reminder_time: reminderDate, userId: userId, edited_date: editedDate, imageUrl: nil))
                    }
                }
            }
            completion(notes)
        }

    }
    
    func getNotesOfType(_ type:Constant.NoteOfType,completion:@escaping ([NoteModel])->Void){

        switch type {
            case .note:
                var dBNotes = [NoteModel]()
                self.getNotes { (notes) in
                    dBNotes = notes
                    let notes = dBNotes.filter({ (note) -> Bool in
                        return note.is_deleted != true && note.is_archived != true
                    })
                    completion(notes)
                }
            case .archive:
                var dBNotes = [NoteModel]()
                self.getNotes { (notes) in
                    dBNotes = notes
                    let notes = dBNotes.filter({ (note) -> Bool in
                        return note.is_deleted != true && note.is_archived == true
                    })
                    completion(notes)
                }
            case .reminder:
                var dBNotes = [NoteModel]()
                self.getNotes { (notes) in
                    dBNotes = notes
                    let notes = dBNotes.filter({ (note) -> Bool in
                        return note.is_deleted != true && note.is_remidered == true
                    })
                    completion(notes)
                }
            case .deleted:
                getDeletedNotes(completion: { (notes) in
                    completion(notes)
                })
                break
            default:
                break
        }
    }
}
