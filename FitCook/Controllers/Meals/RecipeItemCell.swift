import UIKit

class RecipeItemCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var kcalLabel: UILabel!
	@IBOutlet weak var totalKcalLabel: UILabel!
	
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
			self.kcalLabel.textColor = .label
		} else {
			self.kcalLabel.text = "ккал/100гр"
			self.kcalLabel.textColor = .systemGray
		}
		let totalCalories = recipeItem.weight * recipeItem.ingredient!.kcal / 100
		if totalCalories != 0 {
			self.totalKcalLabel.text = String(totalCalories)
		} else {
			self.totalKcalLabel.text = ""
		}
		return self
	}

}
