import UIKit
import CoreData

class MealsViewController: UITableViewController {
	var meals = [Meal]()
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadMeals()
		
	}
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new meal", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add", style: .default) { (action) in
			let newMeal = Meal(context: self.context)
			newMeal.name = textField.text!
			self.meals.append(newMeal)
			self.saveMeals()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(action)
		alert.addAction(cancelAction)
		alert.addTextField { (field) in
			textField = field
			textField.placeholder = "Add new meal"
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
	
	func saveMeals() {
		do {
			try context.save()
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
		let nextVC = segue.destination as! IngredientsViewController
		if let selectedRow = tableView.indexPathForSelectedRow {
			nextVC.meal = meals[selectedRow.row]
		}
	}
	
	
}
