
import Foundation

struct Constant {
    
    struct App{
        static let APP_NAME = "FundooNotes"
    }
    struct Color {
        static let colorWhite = "#ffffff"
        static let colorBlack = "#000000"
        static let colourForFilterOn = "#8187C1"
        static let colourOrange = "#FF9300"
        static let colourReminderText = "#898989"
    }
    
    struct DashboardViewTitle{
        static let noteView = "Notes"
        static let reminderView = "Remindered"
        static let archivedView = "Archived"
        static let deletedView = "Deleted"
    }
    
    enum NoteOfType{
        case note
        case reminder
        case archive
        case deleted
    }
}
