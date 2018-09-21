import Foundation

class TakeNotePresenterService {
    
    func saveNote(note:NoteModel){
        NoteDBManager.saveNote(note: note)
    }
    
    func deleteNote(noteToDelete:NoteModel,completion:(Bool,String)->Void){
        NoteDBManager.deleteNote(noteToDelete: noteToDelete) { (status, message) in
            completion(status, message)
        }
    }
    func deleteNoteT(noteToDelete:NoteModel,completion:(Bool,String)->Void){
        NoteDBManager.deleteNoteT(noteToDelete: noteToDelete) { (status, message) in
            completion(status, message)
        }
    }
    func restoreNote(noteToRestore:NoteModel,completion:(Bool,String)->Void){
        NoteDBManager.restoreNote(note: noteToRestore) { (status, message) in
            completion(status, message)
        }
    }

}
