import Foundation

class TakeNotePresenter{
    let pTakeNoteView:PTakeNoteView?
    let presenterService:TakeNotePresenterService?
    
    init(pTakeNoteView:PTakeNoteView,presenterService:TakeNotePresenterService){
        self.pTakeNoteView = pTakeNoteView
        self.presenterService = presenterService
    }
    
    func getPhoto(_ option: Helper.photoOptionSelected){
        pTakeNoteView?.getPhoto(option)
    }

    func saveNote(note:NoteModel){
        presenterService?.saveNote(note: note)
    }
    
    func updateView(){
        pTakeNoteView?.updateView()
    }
    
    func updateImageView(){
        pTakeNoteView?.updateImageView()
    }
    
    func deleteNote(noteToDelete:NoteModel,completion:(Bool,String)->Void){
        presenterService?.deleteNote(noteToDelete: noteToDelete, completion: { (status, message) in
            completion(status, message)
        })
    }
    func deleteNoteFromTrash(noteToDelete:NoteModel,completion:(Bool,String)->Void){
        presenterService?.deleteNoteT(noteToDelete: noteToDelete, completion: { (status, message) in
            completion(status, message)
        })
    }
    func showAlert(message:String){
            pTakeNoteView?.showAlert(message: message)
    }
    
    func presentDashboardView(){
        pTakeNoteView?.presentDashboardView()
    }
    
    func performPinAction(){
        pTakeNoteView?.pinAction()
    }
    func performArchiveAction(){
        pTakeNoteView?.archiveAction()
    }
    func setUpData(note:NoteModel){
        pTakeNoteView?.setUpData(note: note)
    }
    func setReminder(note:NoteModel){
        pTakeNoteView?.setReminder(note:note)
    }
    func toggleColorOptionTblView(constant: CGFloat){
        pTakeNoteView?.toggleColorOptionTblView(constant: constant)
    }
    
    func restoreNote(noteToRestore:NoteModel,completion:(Bool,String)->Void){
        presenterService?.restoreNote(noteToRestore: noteToRestore, completion: { (status, message) in
            completion(status, message)
        })
    }
}
