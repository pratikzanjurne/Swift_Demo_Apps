import UIKit

class DashboardNoteCell:UICollectionViewCell{
    
    @IBOutlet var superView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleTextLabel: UILabel!
    @IBOutlet var noteTextLabel: UILabel!
    @IBOutlet var dateTextLabel: UILabel!
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageViewHeightConstraint.constant = 0
        self.layer.backgroundColor = UIColor.white.cgColor
        self.noteTextLabel.sizeToFit()
        self.dateTextLabel.sizeToFit()
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
        if let noteImage = note.image{
            let newHeight = Helper.shared.getScaledHeight(imageWidth: noteImage.size.width, imageHeight: noteImage.size.height, scaleWidth: self.bounds.width)
            self.imageViewHeightConstraint.constant = newHeight
            self.imageView.image = noteImage
        }
        self.noteTextLabel.text = note.note
        self.dateTextLabel.text = note.creadted_date
        self.layer.backgroundColor = UIColor(hexString: note.colour).cgColor
    }
    
}

