import UIKit
import CoreData

class IngredientsViewController: UITableViewController {
	
	var ingredients: [Ingredient] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		ingredients = loadAllIngredients()
	}
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ingredients.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
		cell.textLabel?.text = ingredients[indexPath.row].name!
		return cell
	}
	
	override func tableView(_ tableView: UITableView,
							trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		if ingredients[indexPath.row].inRecipe?.count == 0 {
			let delete = UIContextualAction(style: .destructive, title: "Delete") {
				(action, sourceView, completionHandler) in
				deleteIngredient(self.ingredients[indexPath.row])
				self.ingredients.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
				completionHandler(true)
			}
			let config = UISwipeActionsConfiguration(actions: [delete])
			config.performsFirstActionWithFullSwipe = true
			return config
		} else {
			return nil
		}
	}
}
