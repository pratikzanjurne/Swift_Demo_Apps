import Foundation

class DashboardPresenterService {
    func getNotes(completion:([NoteModel])->Void){
        NoteDBManager.getNotes { (notes) in
            completion(notes)
        }
    }
    
    func getDeletedNotes(completion:([NoteModel])->Void){
        NoteDBManager.getDeletedNotes { (notes) in
            completion(notes)
        }
    }
    func getNotesOfType(_ type:Constant.NoteOfType,completion:([NoteModel])->Void){
        NoteDBManager.getNotesOfType(type) { (notes) in
            completion(notes)
        }
    }

}
