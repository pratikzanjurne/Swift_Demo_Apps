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
    
    func compareDate(date:String,time:String,completion:(String)->Void){
        let dateD = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let todaysDate = formatter.string(from: dateD)
        if todaysDate == date{
            completion("Today \(time)")
            return
        }
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day); // +1 day
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: dateD)
        let tomorrowDateString = formatter.string(from: tomorrow!)
        if tomorrowDateString == date{
            completion("Tomorrow \(time)")
        }else{
            completion("\(date) \(time)")
        }
    }

}
