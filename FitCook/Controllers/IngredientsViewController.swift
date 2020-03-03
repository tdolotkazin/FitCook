//
//  ViewController.swift
//  FitCook
//
//  Created by Timur Dolotkazin on 21.02.2020.
//  Copyright © 2020 Timur Dolotkazin. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController {
	
	var meal = [Ingredient(name: "Подсолнечное масло"), Ingredient(name: "Морковь")]
	
	@IBOutlet var toolbar: UIToolbar!
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var ingredientTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		meal[0].weight = 12
		meal[0].kcal = 899
		
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
			ingredientTextField.text! = ingredientTextField.text! + ": "
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
		let weightString = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		let weight = Int(weightString)
		let name = string.components(separatedBy: CharacterSet.decimalDigits).first
		let newIngredient = Ingredient(name: name!, weight: weight)
		//need to implement extra check for ":" in this line. Everything after this line should be weight. Just in case user wants to have name of ingredient with digits, e.g. "Cream of 20% fat"
		meal.insert(newIngredient, at: 0)
		tableView.reloadData()
		ingredientTextField.text = nil
	}
}


//MARK: - TableView methods

extension IngredientsViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meal.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! IngredientsListViewCell
		cell.nameLabel.text = meal[indexPath.row].name
		if let weight = meal[indexPath.row].weight {
			cell.weightLabel.text = "\(weight)гр"
			cell.weightLabel.textColor = .label
		} else {
			cell.weightLabel.text = "гр"
			cell.weightLabel.textColor = .systemGray
		}
		if let kcal = meal[indexPath.row].kcal {
			cell.kcalLabel.text = "\(kcal)ккал/100гр"
			cell.kcalLabel.textColor = .label
		} else {
			cell.kcalLabel.text = "ккал/100гр"
			cell.kcalLabel.textColor = .systemGray
		}
		if let total = meal[indexPath.row].totalkCal {
			cell.totalKcalLabel.text = "\(total)ккал"
			cell.totalKcalLabel.textColor = .systemGray
		} else {
			cell.totalKcalLabel.text = "ккал"
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toIngredientDetail", sender: self)
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
			self.meal.remove(at: indexPath.row)
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
			detailVC.selectedIngredient = meal[indexPath.row]
		}
		
	}
}


