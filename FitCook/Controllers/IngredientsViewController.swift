
import UIKit
import CoreData

class IngredientsViewController: UIViewController {
	//get context from singleton
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	var meal: Meal? {
		didSet {
			loadIngredients(in: meal, to: &ingredients)
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.reloadRows(at: [selectedIndexPath], with: UITableView.RowAnimation.automatic)
			tableView.deselectRow(at: selectedIndexPath, animated: animated)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		save()
	}
	
	//MARK: - IBActions
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		if let string = ingredientTextField.text, string != "" {
			ingredients.insert(parseIngredient(string: string, meal: meal!), at: 0)
			ingredientTextField.text = ""
			tableView.reloadData()
			
		}
		ingredientTextField.resignFirstResponder()
		
	}
	
	@IBAction func weightButtonPressed(_ sender: UIBarButtonItem) {
		if ingredientTextField.text != "" {
			ingredientTextField.text! = ingredientTextField.text! + ": "
			ingredientTextField.keyboardType = .numbersAndPunctuation
			ingredientTextField.reloadInputViews()
		}
	}
	
	@IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Переименовать блюдо", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default) { (alertAction) in
			self.meal?.name = textField.text!
		}
		alert.addAction(action)
		alert.addTextField { (alertTextField) in
			alertTextField.text = self.meal?.name!
			textField = alertTextField
		}
		present(alert, animated: true) {
			save()
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
		ingredients.insert(parseIngredient(string: textField.text!, meal: meal!), at: 0)
		tableView.reloadData()
		ingredientTextField.text = ""
		textField.keyboardType = .default
		textField.reloadInputViews()
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let field = textField as? CustomTextField {
			var textstring = field.text!
			textstring.append(string)
			field.suggest(textstring)
		}
		return true
	}
}

//MARK: - TableView methods

extension IngredientsViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ingredients.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! IngredientsListViewCell
		return cell.showIngredient(ingredients[indexPath.row])
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toIngredientDetail", sender: self)
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
			deleteIngredient(ingredient: self.ingredients[indexPath.row])
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
		if segue.identifier == "toIngredientDetail" {
			let detailVC = segue.destination as! IngredientDetailViewController
			if let indexPath = tableView.indexPathForSelectedRow {
				detailVC.selectedIngredient = ingredients[indexPath.row]
			}
		}
		if segue.identifier == "goToCalculation" {
			let calculationVC = segue.destination as! CalculationViewController
			calculationVC.ingredients = ingredients
			calculationVC.meal = meal
		}
		
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if identifier == "goToCalculation" {
			return checkIfReadyForCalculation(meal: meal!, ingredients: ingredients) { (error) in
				switch error {
					case "Fill Ingredients":
						let alert = UIAlertController(title: "Ну уж нет", message: "Сначала введите вес и калорийность всех ингредиентов =)", preferredStyle: .alert)
						alert.addAction(UIAlertAction(title: "Ну ладно =(", style: .default, handler: nil))
						present(alert, animated: true, completion: nil)
					case "Add Ingredients": let alert = UIAlertController(title: "А из чего готовить будем?", message: "Ну хоть что-нибудь введите =)", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "Ну ладно =(", style: .default, handler: nil))
					present(alert, animated: true, completion: nil)
					default: break
				}
			}
		}
		return true
	}
}
