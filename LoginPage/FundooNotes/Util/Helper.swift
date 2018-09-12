import Foundation
import UIKit

class Helper {
    static let shared = Helper()
    
    private init(){
        
    }
    
    func getScaledHeight(imageWidth:CGFloat,imageHeight:CGFloat,scaleWidth:CGFloat) -> CGFloat{
        let oldWidth = imageWidth
        let scalFactor = scaleWidth/oldWidth
        return imageHeight * scalFactor
    }
    enum photoOptionSelected {
        case camera
        case gallary
    }
    
    enum reminderOptionSelected{
        case date
        case time
        case repeate
    }
    
    enum sideMenuOptionSelected {
        case notes
        case reminder
        case archived
        case deleted
    }

}
