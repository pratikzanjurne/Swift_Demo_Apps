import Foundation

class TakeNotePresenterService {
    
    func saveNote(note:NoteModel){
        NoteDBManager.saveNote(note: note)
        FirebaseDBManager.shared.saveNote(note: note)
    }
    
    func deleteNote(noteToDelete:NoteModel,completion:@escaping (Bool,String)->Void){
//        NoteDBManager.deleteNote(noteToDelete: noteToDelete) { (status, message) in
//            completion(status, message)
//        }
        FirebaseDBManager.shared.deleteNote(noteToDelete: noteToDelete) { (result, message) in
            completion(result, message)
        }
    }
    func deleteNoteFromTrash(noteToDelete:NoteModel,completion:@escaping (Bool,String)->Void){
//        NoteDBManager.deleteNoteT(noteToDelete: noteToDelete) { (status, message) in
//            completion(status, message)
//        }
        FirebaseDBManager.shared.deleteNoteFromTrash(noteToDelete: noteToDelete) { (result, message) in
            completion(result, message)
        }
    }
    func restoreNote(noteToRestore:NoteModel,completion:@escaping (Bool,String)->Void){
//        NoteDBManager.restoreNote(note: noteToRestore) { (status, message) in
//            completion(status, message)
//        }
        FirebaseDBManager.shared.restoreNoteFromTrash(noteToRestore: noteToRestore) { (result, message) in
            completion(result, message)
        }
    }

}
