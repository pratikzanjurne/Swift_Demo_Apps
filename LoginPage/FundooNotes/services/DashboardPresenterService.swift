import Foundation

class DashboardPresenterService {
    func getNotes(completion:@escaping ([NoteModel])->Void){
//        NoteDBManager.getNotes { (notes) in
//            completion(notes)
//        }
        FirebaseDBManager.shared.getNotes { (notes) in
            completion(notes)
        }
    }
    
    func getDeletedNotes(completion:@escaping ([NoteModel])->Void){
//        NoteDBManager.getDeletedNotes { (notes) in
//            completion(notes)
//        }
        FirebaseDBManager.shared.getDeletedNotes { (notes) in
            completion(notes)
        }
    }
    func getNotesOfType(_ type:Constant.NoteOfType,completion:@escaping ([NoteModel])->Void){
//        NoteDBManager.getNotesOfType(type) { (notes) in
//            completion(notes)
//        }
        FirebaseDBManager.shared.getNotesOfType(type) { (notes) in
            completion(notes)
        }
    }
    
    func pinNoteArray(notes:[NoteModel],completion:@escaping (Bool,String)->Void){
//        NoteDBManager.pinNoteArray(notes: notes) { (status,message) in
//            completion(status,message)
//        }
        FirebaseDBManager.shared.pinNoteArray(notes: notes) { (status, message) in
            completion(status, message)
        }
    }

}
