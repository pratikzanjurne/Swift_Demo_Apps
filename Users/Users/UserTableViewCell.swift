import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var cellView: UIView!
    @IBOutlet var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.borderWidth = 2
        cellView.layer.borderColor = UIColor.black.cgColor
        cellView.layer.cornerRadius = 15
        cellView.layer.masksToBounds = true
        cellView.layer.shadowColor = UIColor.green.cgColor
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
