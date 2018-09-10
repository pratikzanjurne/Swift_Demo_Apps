import UIKit

class NoteView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var noteTextView: UITextView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleHeightContraint: NSLayoutConstraint!
    @IBOutlet var imageViewHeightC: NSLayoutConstraint!
    @IBOutlet var noteHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    private func commitInit(){
        Bundle.main.loadNibNamed("NoteView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
}
