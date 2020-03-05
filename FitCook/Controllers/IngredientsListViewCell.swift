import UIKit

class IngredientsListViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var totalKcalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	func showIngredient(_ recipeItem: RecipeItem) -> IngredientsListViewCell {
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
			self.kcalLabel.textColor = .label
		} else {
			self.kcalLabel.text = "ккал/100гр"
			self.kcalLabel.textColor = .systemGray
		}
		return self
	}

}
