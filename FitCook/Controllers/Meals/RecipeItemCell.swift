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
			self.weightLabel.text = "\(weight)гр"
			self.weightLabel.textColor = .label
		} else {
			self.weightLabel.text = "гр"
			self.weightLabel.textColor = .systemGray
		}
		let kcal = recipeItem.ingredient!.kcal
		if kcal != 0 {
			self.kcalLabel.text = "\(kcal)ккал/100гр"
		} else {
			self.kcalLabel.text = "ккал/100гр"
		}
		return self
	}
	
}
