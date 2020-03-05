import UIKit
import CoreData

class MealsViewController: UITableViewController {
	
	var meals = [Meal]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadMeals()
	}
	override func viewDidAppear(_ animated: Bool) {
		tableView.reloadData()
		//transfer tableView row deselection here. And as we deselect - we know indexPath - we can reload only one row.
	}
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new meal", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add", style: .default) { (action) in
			let newMeal = Meal(context: self.context)
			newMeal.name = textField.text!
			self.meals.append(newMeal)
			save()
			self.tableView.reloadData()
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
	
	func loadMeals() {
		let request: NSFetchRequest<Meal> = Meal.fetchRequest()
		do {
			try meals = context.fetch(request)
		} catch {
			print(error)
		}
		tableView.reloadData()
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return meals.count
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
		cell.textLabel?.text = meals[indexPath.row].name
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toIngredients", sender: self)
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
			self.context.delete(self.meals[indexPath.row])
			save()
			self.meals.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
			completionHandler(true)
		}
		let config = UISwipeActionsConfiguration(actions: [delete])
		config.performsFirstActionWithFullSwipe = true
		return config
	}
	
	
	/*
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the specified item to be editable.
	return true
	}
	*/
	
	/*
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
	if editingStyle == .delete {
	// Delete the row from the data source
	tableView.deleteRows(at: [indexPath], with: .fade)
	} else if editingStyle == .insert {
	// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
	}
	*/
	
	/*
	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
	
	}
	*/
	
	/*
	// Override to support conditional rearranging of the table view.
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the item to be re-orderable.
	return true
	}
	*/
	
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let nextVC = segue.destination as! RecipeViewController
		if let selectedRow = tableView.indexPathForSelectedRow {
			nextVC.meal = meals[selectedRow.row]
		}
	}
	
	
}
