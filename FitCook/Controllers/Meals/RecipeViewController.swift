import UIKit
import CoreData

class RecipeVC: UIViewController {
	
	var coreData: CoreDataHelper?
	var meal: Meal?
	private var recipeItems = [RecipeItem]()
	
	@IBOutlet var toolbar: UIToolbar!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var ingredientTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = meal!.name
		recipeItems = Array(meal!.recipeItems!)
		tableView.register(UINib(nibName: "RecipeItemCell", bundle: .main), forCellReuseIdentifier: "recipeItemCell")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadAndDeselectRow()
	}
	
	func showAlert(title: String, actionTitle: String) {
		let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true) {
			self.ingredientTextField.text = ""
		}
	}
	
	//MARK: - IBActions
	
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		let string = ingredientTextField.text!
		if string != "" {
			if let newRecipeItem = coreData?.addRecipeItem(from: string, to: &recipeItems) { newRecipeItem.inMeal = meal
				recipeItems.insert(newRecipeItem, at: 0)
				tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
				ingredientTextField.text = ""
			} else {
				showAlert(title: "Уже есть такой ингредиент", actionTitle: "ОК")
			}
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
			self.coreData!.save()
		}
	}
}

//MARK: - UITextfield Delegate

extension RecipeVC: UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		textField.inputAccessoryView = toolbar
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let string = ingredientTextField.text!
		if string != "" {
			if let newRecipeItem = coreData?.addRecipeItem(from: string, to: &recipeItems) {
				newRecipeItem.inMeal = meal
				recipeItems.insert(newRecipeItem, at: 0)
				tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
			} else {
				showAlert(title: "Уже есть такой ингредиент", actionTitle: "OK")
			}
			ingredientTextField.text = ""
			textField.keyboardType = .default
			textField.reloadInputViews()
			return true
		}
		return false
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let field = textField as? CustomTextField {
			field.coreData = coreData
			var textstring = field.text!
			textstring.append(string)
			field.showSuggestions(name: textstring)
		}
		return true
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		let string = ingredientTextField.text!
		if string != "" {
			if let newRecipeItem = coreData?.addRecipeItem(from: string, to: &recipeItems) { newRecipeItem.inMeal = meal
				recipeItems.insert(newRecipeItem, at: 0)
				tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
				ingredientTextField.text = ""
				coreData?.save()
			} else {
				showAlert(title: "Уже есть такой ингредиент", actionTitle: "OK")
			}
		}
	}
}

//MARK: - TableView methods

extension RecipeVC: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return recipeItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "recipeItemCell") as! RecipeItemCell
		return cell.showIngredient(recipeItems[indexPath.row])
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toIngredientDetail", sender: self)
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
			self.coreData?.deleteRecipeItem(recipeItem: self.recipeItems[indexPath.row])
			self.recipeItems.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
			completionHandler(true)
		}
		let config = UISwipeActionsConfiguration(actions: [delete])
		config.performsFirstActionWithFullSwipe = true
		return config
	}
	
}
//MARK: - Navigation

extension RecipeVC {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toIngredientDetail" {
			let detailVC = segue.destination as! RecipeItemViewController
			if let indexPath = tableView.indexPathForSelectedRow {
				detailVC.selectedRecipeItem = recipeItems[indexPath.row]
				detailVC.coreData = coreData
			}
		}
		if segue.identifier == "goToCalculation" {
			let calculationVC = segue.destination as! CalculationViewController
			calculationVC.ingredients = recipeItems
			calculationVC.meal = meal
			calculationVC.coreData = coreData
		}
		
	}
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if identifier == "goToCalculation" {
			return checkIfReadyForCalculation(ingredients: recipeItems) { (error) in
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
