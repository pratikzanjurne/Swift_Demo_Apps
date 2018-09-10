import Foundation
import UIKit

class DashboardPresenter{
    let pDashboardView:PDashboardView?
    let presenterService:DashboardPresenterService?
    
    init(pDashboardView:PDashboardView,presenterService:DashboardPresenterService){
        self.pDashboardView = pDashboardView
        self.presenterService = presenterService
    }
    
    func getNotes(){
        pDashboardView?.startLoading()
        presenterService?.getNotes(completion: { (notes) in
            pDashboardView?.stopLoading()
            pDashboardView?.setNotes(notes: notes)
        })
        
    }
    
    func getCellHeight(note:NoteModel,width:CGFloat,completion:(_ Height:CGFloat)->Void){
        var height:CGFloat = 40
        self.computeTextLabelHeight(text: note.note, width: width) { (noteHeight) in
            height = height + noteHeight
        }
        self.computeTextLabelHeight(text: note.creadted_date,  width: width) { (dateHeight) in
            height = height + 30
        }
        if let noteImage = note.image{
            self.computeImageHeight(image: noteImage, width: width) { (imageHeight) in
                height = height + imageHeight
            }
        }
        completion(height)
        
    }
    
    func computeTextLabelHeight(text:String,width:CGFloat,completion:(CGFloat)->Void){
        let labelText = UILabel()
        labelText.numberOfLines = 0
        labelText.lineBreakMode = .byWordWrapping
        labelText.text = text
        labelText.preferredMaxLayoutWidth = (width) - 32
        labelText.invalidateIntrinsicContentSize()
        completion(labelText.intrinsicContentSize.height)
    }
    
    func computeImageHeight(image:UIImage,width:CGFloat,completion:(CGFloat)->Void){
        let height =  width / image.getAspectRatio()
//        completion(height)
        let newHeight =  Helper.shared.getScaledHeight(imageWidth: image.size.width, imageHeight: image.size.height, scaleWidth: width)
        completion(newHeight)
    }
}
