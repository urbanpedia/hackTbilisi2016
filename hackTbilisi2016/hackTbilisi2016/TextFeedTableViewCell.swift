import UIKit

class TextFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var feedLabel: UILabel!
    @IBOutlet weak var imageWrapper: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
