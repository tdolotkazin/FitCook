import UIKit
import CoreData

class MealsViewController: UITableViewController {
	
	private var meals = [Meal]()
	private let coreData = CoreDataHelper()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		meals = coreData.load()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if let selectedRow = tableView.indexPathForSelectedRow {
			tableView.rectForRow(at: selectedRow)
			tableView.deselectRow(at: selectedRow, animated: true)
		}
	}
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new meal", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add", style: .default) { (action) in
			if let name = textField.text {
				let newMeal: Meal = self.coreData.create(named: name)
				self.meals.append(newMeal)
				self.tableView.insertRows(at: [IndexPath(row: self.meals.count - 1, section: 0)], with: .automatic)
			} else {
				fatalError("Enter new meal name!")
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(action)
		alert.addAction(cancelAction)
		alert.addTextField { (field) in
			textField = field
			textField.placeholder = "Add new meal"
			textField.autocapitalizationType = .sentences
		}
		present(alert, animated: true, completion: nil)
	}
}

//MARK: - TableView Data Source

extension MealsViewController {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meals.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
		cell.textLabel?.text = meals[indexPath.row].name
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
			self.coreData.delete(self.meals[indexPath.row])
			self.meals.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
			completionHandler(true)
		}
		let config = UISwipeActionsConfiguration(actions: [delete])
		config.performsFirstActionWithFullSwipe = true
		return config
	}
	
}

//MARK: - TableView Delegate

extension MealsViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toIngredients", sender: self)
	}
}

//MARK: - Navigation

extension MealsViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let nextVC = segue.destination as! RecipeViewController
		if let selectedRow = tableView.indexPathForSelectedRow {
			nextVC.meal = meals[selectedRow.row]
			nextVC.coreData = coreData
		}
	}
}
