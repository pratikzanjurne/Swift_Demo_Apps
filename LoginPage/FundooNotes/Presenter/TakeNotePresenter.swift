import Foundation

class TakeNotePresenter{
    let pTakeNoteView:PTakeNoteView?
    let presenterService:TakeNotePresenterService?
    
    init(pTakeNoteView:PTakeNoteView,presenterService:TakeNotePresenterService){
        self.pTakeNoteView = pTakeNoteView
        self.presenterService = presenterService
    }
    
    func getPhoto(_ option: UIHelper.photoOptionSelected){
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
}
