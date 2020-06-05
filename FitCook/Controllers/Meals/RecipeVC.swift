import UIKit
import CoreData

class RecipeVC: UIViewController, UIAdaptivePresentationControllerDelegate {
	
	var coreData: CoreDataHelper!
	var meal: Meal!
	private var recipeItems = [RecipeItem]()
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var textField: CustomTextField!
	@IBOutlet weak var calculateButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		calculateButton.layer.cornerRadius = 8
		title = meal.name
		recipeItems = meal.getRecipeItems()
		tableView.register(UINib(nibName: "RecipeItemCell", bundle: .main), forCellReuseIdentifier: "recipeItemCell")
		tableView.separatorStyle = .none
		let toolbar = CustomToolbar(leftButtonType: .Weight, rightButtonType: .Done)
		textField.inputAccessoryView = toolbar
//		textField.keyboardType = .default
		toolbar.buttonDelegate = self
		buildIngredientsButton()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadAndDeselectRow()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		textField.tableView?.removeFromSuperview()
		textField.tableView = nil
	}
	
	
	
	func buildIngredientsButton() {
		let ingredientsButton = UIButton()
			ingredientsButton.translatesAutoresizingMaskIntoConstraints = false
			textField.addSubview(ingredientsButton)
			ingredientsButton.tintColor = .black
			ingredientsButton.setImage(UIImage(systemName: "book"), for: .normal)
			ingredientsButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
			ingredientsButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
			ingredientsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
			ingredientsButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
			ingredientsButton.addTarget(self, action: #selector(ingredientsButtonPressed), for: .touchUpInside)
		}

	//Alert presenting method
	func showAlert(title: String, actionTitle: String) {
		let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
		alert.addAction(action)
		alert.view.layoutIfNeeded()
		present(alert, animated: true) {
			self.textField.text = ""
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
			let ingredientExistsTitle = NSLocalizedString("Ingredient already exists", comment: "Alert showing that ingredient already exists")
			let OKTitle = NSLocalizedString("OK", comment: "OK title for alerts")
			showAlert(title: ingredientExistsTitle, actionTitle: OKTitle)
			return
		}
		
		//creating new item
		let newRecipeItem = coreData.addRecipeItem(named: parsedItem.name)
		newRecipeItem.weight = parsedItem.weight
		newRecipeItem.inMeal = meal
		recipeItems.insert(newRecipeItem, at: 0)
		tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
		textField.tableView?.isHidden = true
		
		//check if need to save CoreData!!!!
		coreData.save()
		
	}
	//MARK: - IBActions
	
	//"Edit" button is pressed in the Navigation bar.
	
	@IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let dishRenameTitle = NSLocalizedString("Rename dish", comment: "Title for rename dish alert")
		let alert = UIAlertController(title: dishRenameTitle, message: nil, preferredStyle: .alert)
		let okTitle = NSLocalizedString("OK", comment: "OK title for alerts")
		let action = UIAlertAction(title: okTitle, style: .default) { (alertAction) in
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

@objc func ingredientsButtonPressed() {
	if let ingredientsVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "IngredientsVC") as? IngredientsVC {
		ingredientsVC.coreData = coreData
		navigationController?.pushViewController(ingredientsVC, animated: true)
	} else {
		fatalError("No Ingredients Controller!")
	}
}
	
	@IBAction func calculationButtonPressed(_ sender: UIButton) {
		if (checkIfReadyForCalculation(ingredients: recipeItems) { (error) in
			switch error {
				case "Fill Ingredients":
					let enterAllIngredientsFirst = NSLocalizedString("Fill all ingredients weight and nutrition facts first", comment: "Alert explainig that user have to enter all ingredients first")
					let alert = UIAlertController(title: enterAllIngredientsFirst, message: nil, preferredStyle: .alert)
					let okTitle = NSLocalizedString("OK", comment: "OK title for alerts")
					alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: nil))
					present(alert, animated: true, completion: nil)
				case "Add Ingredients":
					let noIngredients = NSLocalizedString("Add ingredient", comment: "Alert showing there are no ingredients")
					let alert = UIAlertController(title: noIngredients, message: nil, preferredStyle: .alert)
					let okTitle = NSLocalizedString("OK", comment: "OK title for alerts")
					alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: nil))
				present(alert, animated: true, completion: nil)
				default: break
			}
		})
		 {
			performSegue(withIdentifier: "toCalculation", sender: self)
		}
	}
}

extension RecipeVC: CustomToolbarDelegate {
	func donePressed(toolbar: CustomToolbar) {
		let string = textField.text!
		createNewItem(from: string)
		textField.text = ""
		textField.resignFirstResponder()
	}
	
	func nextPressed(toolbar: CustomToolbar) {
		
	}
	
	func weightPressed(toolbar: CustomToolbar) {
		if textField.text != "" {
			textField.text! = textField.text! + ": "
			textField.keyboardType = .numbersAndPunctuation
			textField.reloadInputViews()
		}
	}
}


//MARK: - UITextfield Delegate

extension RecipeVC: UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let string = textField.text!
		if string == "" {
			return false
		}
		createNewItem(from: string)
		textField.text = ""
		textField.keyboardType = .default
		textField.reloadInputViews()
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let field = textField as? CustomTextField {
			field.coreData = coreData
			if let text = field.text, let textRange = Range(range, in: text) {
				let finalText = text.replacingCharacters(in: textRange, with: string)
				field.showSuggestions(name: finalText)
			}
		}
		return true
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		let string = textField.text!
		createNewItem(from: string)
		textField.text = ""
	}
}

//MARK: - TableView methods

extension RecipeVC: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return recipeItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "recipeItemCell") as! RecipeItemCell
		cell.setGradient(row: indexPath.row, of: recipeItems.count)
		return cell.showIngredient(recipeItems[indexPath.row])
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let pageVC = RecipePageVC()
		pageVC.coreData = coreData
		pageVC.recipeItems = recipeItems
		pageVC.selectedItemIndex = indexPath.row
		navigationController?.pushViewController(pageVC, animated: true)
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteTitle = NSLocalizedString("Delete", comment: "Delete button")
		let delete = UIContextualAction(style: .destructive, title: deleteTitle) { (action, sourceView, completionHandler) in
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
		textField.tableView?.removeFromSuperview()
		if segue.identifier == "toIngredientDetail" {
			let detailVC = segue.destination as! RecipeItemVC
			detailVC.presentationController?.delegate = self
			if let indexPath = tableView.indexPathForSelectedRow {
				detailVC.recipeItem = recipeItems[indexPath.row]
				detailVC.coreData = coreData
			}
		}
		if segue.identifier == "toCalculation" {
			let calculationVC = segue.destination as! CalculationVC
			calculationVC.ingredients = recipeItems
			calculationVC.meal = meal
			calculationVC.coreData = coreData
		}
	}
}
