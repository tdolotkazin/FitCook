import UIKit
import CoreData

class RecipeVC: UIViewController, UIAdaptivePresentationControllerDelegate {
	
	var coreData: CoreDataHelper!
	var meal: Meal!
	private var recipeItems = [RecipeItem]()
	
	@IBOutlet var toolbar: UIToolbar!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var ingredientTextField: CustomTextField!
	@IBOutlet weak var calculateButton: UIButton!
	
	//preparing the view to show
	override func viewDidLoad() {
		super.viewDidLoad()
		calculateButton.layer.cornerRadius = 8
		title = meal.name
		recipeItems = Array(meal.recipeItems!)
		tableView.register(UINib(nibName: "RecipeItemCell", bundle: .main), forCellReuseIdentifier: "recipeItemCell")
		tableView.separatorStyle = .none
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden = false
	}
	
	//deselecting row when getting back from detailed view
	func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
		tableView.reloadAndDeselectRow()
	}
	
	//Alert presenting method
	func showAlert(title: String, actionTitle: String) {
		let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
		alert.addAction(action)
		alert.view.layoutIfNeeded()
		present(alert, animated: true) {
			self.ingredientTextField.text = ""
		}
	}
	
	func createNewItem(from string: String) {
		//check for empty string
		if string == "" {
			return
		}
		
		//parse string to name and weight
		let parsedItem = parseRecipe(string)
		
		//check if already has this item
		if recipeItems.contains(where: { (recipeItem) -> Bool in
			recipeItem.ingredient?.name == parsedItem.name
		}) {
			showAlert(title: "Уже есть такой ингредиент", actionTitle: "OK")
			return
		}
		
		//creating new item
		let newRecipeItem = coreData.addRecipeItem(named: parsedItem.name)
		newRecipeItem.weight = parsedItem.weight
		newRecipeItem.inMeal = meal
		recipeItems.insert(newRecipeItem, at: 0)
		tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
		ingredientTextField.tableView?.isHidden = true

		//check if need to save CoreData!!!!
		coreData.save()
		
	}
	
	//MARK: - IBActions
	
	//Done button is pressed on the toolbar.
	
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		//taking new item name
		let string = ingredientTextField.text!
		createNewItem(from: string)
		ingredientTextField.text = ""
		ingredientTextField.resignFirstResponder()
	}
	
	//":weight" button is pressed on the toolbar.
	
	@IBAction func weightButtonPressed(_ sender: UIBarButtonItem) {
		if ingredientTextField.text != "" {
			ingredientTextField.text! = ingredientTextField.text! + ": "
			ingredientTextField.keyboardType = .numbersAndPunctuation
			ingredientTextField.reloadInputViews()
		}
	}
	
	//"Edit" button is pressed in the Navigation bar.
	
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
		if string == "" {
			return false
		}
		createNewItem(from: string)
		ingredientTextField.text = ""
		textField.keyboardType = .default
		textField.reloadInputViews()
		return true
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
		createNewItem(from: string)
		ingredientTextField.text = ""
	}
}

//MARK: - TableView methods

extension RecipeVC: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return recipeItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "recipeItemCell") as! RecipeItemCell
		let tempIndex = CGFloat(recipeItems.count - (indexPath.row + 1)) * 0.1
		let cellAlpha = 1 - tempIndex
		let gradientColor = cell.backgroundColor?.withAlphaComponent(cellAlpha)
		cell.backgroundColor = gradientColor
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
		ingredientTextField.tableView?.removeFromSuperview()
		if segue.identifier == "toIngredientDetail" {
			let detailVC = segue.destination as! RecipeItemVC
			detailVC.presentationController?.delegate = self
			if let indexPath = tableView.indexPathForSelectedRow {
				detailVC.selectedRecipeItem = recipeItems[indexPath.row]
				detailVC.coreData = coreData
			}
		}
		if segue.identifier == "goToCalculation" {
			let calculationVC = segue.destination as! CalculationVC
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
