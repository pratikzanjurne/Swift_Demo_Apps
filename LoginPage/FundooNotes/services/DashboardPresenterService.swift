import Foundation

class DashboardPresenterService {
    func getNotes(completion:([NoteModel])->Void){
        NoteDBManager.getNotes { (notes) in
            completion(notes)
        }
    }

}
