import UIKit

class DashboardNoteCell:UICollectionViewCell{
    
    @IBOutlet var superView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scheduleImageView: UIImageView!
    @IBOutlet var noteTextLabel: UILabel!
    @IBOutlet var dateTextLabel: UILabel!
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var pinImageConstraint: NSLayoutConstraint!
    @IBOutlet var reminderTextView:UIView!
    @IBOutlet var reminderTextViewHConstraint:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageViewHeightConstraint.constant = 0
        self.layer.backgroundColor = UIColor.white.cgColor
        self.noteTextLabel.sizeToFit()
        self.dateTextLabel.sizeToFit()
        self.scheduleImageView.tintColor = UIColor(hexString: Constant.Color.colourReminderText)
        self.reminderTextView.layer.cornerRadius = 2
        UIHelper.shared.setCornerRadius(view: reminderTextView)
        noteTextLabel.lineBreakMode = .byWordWrapping
        noteTextLabel.numberOfLines = 0
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dateTextLabel.text = nil
        self.imageView.image = nil
        self.noteTextLabel.text = nil
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.imageViewHeightConstraint.constant = 0
    }
    
    func setData(note:NoteModel){
        if let imageData = note.image{
            if let noteImage = UIImage(data:imageData as Data){
                let newHeight = Helper.shared.getScaledHeight(imageWidth: noteImage.size.width, imageHeight: noteImage.size.height, scaleWidth: self.bounds.width)
                self.imageViewHeightConstraint.constant = newHeight
                self.imageView.image = noteImage
            }
        }
        self.noteTextLabel.text = note.note
        if note.is_remidered{
            self.reminderTextViewHConstraint.constant = 18
            self.dateTextLabel.text =  "\(note.reminder_date!) \(note.reminder_time!)"
        }else{
            self.reminderTextViewHConstraint.constant = 0
        }
        dateTextLabel.sizeToFit()
        dateTextLabel.clipsToBounds = true
        dateTextLabel.layer.cornerRadius = 5
        self.layer.backgroundColor = UIColor(hexString: note.colour).cgColor
        if note.is_pinned{
            self.pinImageConstraint.constant = 18
        }else{
            self.pinImageConstraint.constant = 0
        }
    }
    
}

