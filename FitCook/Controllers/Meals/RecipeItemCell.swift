import UIKit

class RecipeItemCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var kcalLabel: UILabel!
	@IBOutlet weak var weightLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	func showIngredient(_ recipeItem: RecipeItem) -> RecipeItemCell {
		self.nameLabel.text = recipeItem.ingredient!.name
		let weight = recipeItem.weight
		if weight != 0 {
			let gr = NSLocalizedString("gr", comment: "Unit measurment of gramms")
			self.weightLabel.text = String(weight)+gr
			self.weightLabel.textColor = .label
		} else {
			self.weightLabel.text = NSLocalizedString("gr", comment: "Unit measurment of gramms")
			self.weightLabel.textColor = .systemGray
		}
		let kcal = recipeItem.ingredient!.kcal
		if kcal != 0 {
			let kcalPerWeight = NSLocalizedString("kcal/100gr", comment: "Unit of measurement of calories per weight")
			self.kcalLabel.text = String(kcal)+kcalPerWeight
		} else {
			self.kcalLabel.text = NSLocalizedString("kcal/100gr", comment: "Unit of measurement of calories per weight")
		}
		return self
	}
	
}
