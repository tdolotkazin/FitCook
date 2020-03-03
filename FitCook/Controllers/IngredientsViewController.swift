
import UIKit
import CoreData

class IngredientsViewController: UIViewController {
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	var meal: Meal? {
		didSet {
			loadIngredients(meal!)
		}
	}
	var ingredients = [Ingredient]()
	
	
	@IBOutlet var toolbar: UIToolbar!
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var ingredientTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.reloadData()
	}
	//MARK: - CoreData
	
	func loadIngredients(_ meal: Meal) {
		let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
		let mealPredicate = NSPredicate(format: "%@ IN inMeals", meal)
		request.predicate = mealPredicate
		do {
			ingredients = try context.fetch(request)
		} catch {
			print("Error loading ingredients! \(error)")
		}
	}
	
	func saveIngrediends() {
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print(error)
			}
			tableView.reloadData()
		}
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.reloadRows(at: [selectedIndexPath], with: UITableView.RowAnimation.automatic)
			tableView.deselectRow(at: selectedIndexPath, animated: animated)
			
		}
	}
	
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		if let string = ingredientTextField.text, string != "" {
			parseAndSave(string: string)
		}
		ingredientTextField.resignFirstResponder()
	}
	
	@IBAction func weightButtonPressed(_ sender: UIBarButtonItem) {
		if ingredientTextField.text != "" {
			ingredientTextField.text! = ingredientTextField.text! + " : "
		}
	}
}

//MARK: - UITextfield Delegate

extension IngredientsViewController: UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		textField.inputAccessoryView = toolbar
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text, !text.isEmpty else {
			print("Error")
			return false
		}
		parseAndSave(string: text)
		return true
	}
	
	func parseAndSave(string: String) {
		let name = string.components(separatedBy: " ").first
		let newIngredient = Ingredient(context: self.context)
		newIngredient.name = name
		let weightString = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		if let weight = Int(weightString) {
			newIngredient.weight = Int64(weight) }
		newIngredient.addToInMeals(meal!)
		//need to implement extra check for ":" in this line. Everything after this line should be weight. Just in case user wants to have name of ingredient with digits, e.g. "Cream of 20% fat"
		ingredients.insert(newIngredient, at: 0)
		saveIngrediends()
		tableView.reloadData()
		ingredientTextField.text = nil
	}
}


//MARK: - TableView methods

extension IngredientsViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ingredients.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! IngredientsListViewCell
		cell.nameLabel.text = ingredients[indexPath.row].name
		let weight = ingredients[indexPath.row].weight
		if weight != 0 {
			cell.weightLabel.text = "\(weight)гр"
			cell.weightLabel.textColor = .label
		} else {
			cell.weightLabel.text = "гр"
			cell.weightLabel.textColor = .systemGray
		}
		let kcal = ingredients[indexPath.row].kcal
		if kcal != 0 {
			cell.kcalLabel.text = "\(kcal)ккал/100гр"
			cell.kcalLabel.textColor = .label
		} else {
			cell.kcalLabel.text = "ккал/100гр"
			cell.kcalLabel.textColor = .systemGray
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toIngredientDetail", sender: self)
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
			self.context.delete(self.ingredients[indexPath.row])
			self.saveIngrediends()
			self.ingredients.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
			completionHandler(true)
		}
		let config = UISwipeActionsConfiguration(actions: [delete])
		config.performsFirstActionWithFullSwipe = true
		return config
	}
	
}
//MARK: - Navigation

extension IngredientsViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let detailVC = segue.destination as! IngredientDetailViewController
		if let indexPath = tableView.indexPathForSelectedRow {
			detailVC.selectedIngredient = ingredients[indexPath.row]
		}
	}
}


