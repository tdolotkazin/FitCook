import UIKit

protocol KitchenWareCellDelegate {
	func cellButtonPressed(cell: KitchenWareCell)
}

class KitchenWareCell: UITableViewCell {

	var delegate: KitchenWareCellDelegate?
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var weightLabel: UILabel!
	@IBOutlet weak var imageButton: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	@IBAction func imageButtonPressed(_ sender: UIButton) {
		delegate?.cellButtonPressed(cell: self)
	}
	
}
