//
//  ViewController.swift
//  FitCook
//
//  Created by Timur Dolotkazin on 21.02.2020.
//  Copyright © 2020 Timur Dolotkazin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	var activeTextField: UITextField?
	var selectedRow: IndexPath?
	var meal = [Ingredient(name: "Подсолнечное масло"), Ingredient(name: "Морковь")]

	@IBOutlet var toolbar: UIToolbar!
	
	@IBOutlet weak var toolBarButton: UIBarButtonItem!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var ingredientTextField: UITextField!
	@IBOutlet weak var weightTextField: UITextField!
	@IBOutlet weak var kcalTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		meal[0].weight = 12
		meal[0].kcal = 899
		//        meal[1].weight = 220
		//        meal[1].kcal = 300
		// Do any additional setup after loading the view.
	}
	
	@IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
		switch activeTextField {
			case ingredientTextField:
				weightTextField.becomeFirstResponder()
			case weightTextField:
				kcalTextField.becomeFirstResponder()
			case kcalTextField: kcalTextField.resignFirstResponder()
			default:
			print("error")
		}
		
	}
	
//	@IBAction func addButtonPressed(_ sender: UIButton) {
//		if ingredientTextField.text != "" {
//			let newIngredient = Ingredient(name: ingredientTextField.text!)
//			newIngredient.weight = Int(weightTextField.text ?? "0")
//			newIngredient.kcal = Int(kcalTextField.text ?? "0")
//			meal.insert(newIngredient, at: 0)
//			clearTextFields()
//			activeTextField?.resignFirstResponder()
//			tableView.reloadData()
//
//		}
//	}
}


//MARK: - UITextfield Delegate

extension ViewController: UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if textField != kcalTextField {
			toolBarButton.title = "Next"
			textField.inputAccessoryView = toolbar }
		else {
			toolBarButton.title = "Done"
			textField.inputAccessoryView = toolbar
		}
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		activeTextField = textField
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let row = selectedRow {
			if ingredientTextField.text != "" {
				meal[row.row].name = ingredientTextField.text!
				meal[row.row].weight = Int(weightTextField.text ?? "0")
				meal[row.row].kcal = Int(kcalTextField.text ?? "0")
			} else {
				print("Enter ingredient name!")
				return false
			}
			tableView.deselectRow(at: row, animated: true)
			selectedRow = nil
			tableView.reloadRows(at: [row], with: UITableView.RowAnimation.automatic)
			textField.resignFirstResponder()
			clearTextFields()
			return true
		} else {
			//create new ingredient
			if ingredientTextField.text != "" {
				let newIngredient = Ingredient(name: ingredientTextField.text!)
				newIngredient.weight = Int(weightTextField.text ?? "0")
				newIngredient.kcal = Int(kcalTextField.text ?? "0")
				meal.insert(newIngredient, at: 0)
				clearTextFields()
				tableView.reloadData()
			} else {
				print("Enter ingredient name!")
				return false
			}
			return true
		}
	}
	func clearTextFields() {
		ingredientTextField.text = ""
		weightTextField.text = ""
		kcalTextField.text = ""
	}
	
	
	
}

//MARK: - TableView methods

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	
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
		selectedRow = indexPath
		ingredientTextField.text = meal[selectedRow!.row].name
		if let weight = meal[selectedRow!.row].weight {
			weightTextField.text = "\(weight)"
		}
		if let kcal = meal[selectedRow!.row].kcal {
			kcalTextField.text = "\(kcal)"
		}
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		selectedRow = nil
		clearTextFields()
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
			self.meal.remove(at: indexPath.row)
			if self.selectedRow == indexPath {
				self.selectedRow = nil
			}
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
			completionHandler(true)
		}
		let config = UISwipeActionsConfiguration(actions: [delete])
		config.performsFirstActionWithFullSwipe = true
		return config
	}
	
}



