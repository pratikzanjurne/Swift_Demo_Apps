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

}
