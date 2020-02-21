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
    var meal = [Ingredient(name: "Подсолнечное масло"), Ingredient(name: "Морковь")]
    
    
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var kcalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meal[0].weight = 12
        meal[0].kcal = 999
        //        meal[1].weight = 220
        //        meal[1].kcal = 300
        // Do any additional setup after loading the view.
    }
    
    
    //        if ingredientTextField.text != "" {
    //            let newIngredient = Ingredient(name: ingredientTextField.text!)
    //            if weightTextField.text != "" {
    //                newIngredient.weight = Int(weightTextField.text!)
    //            }
    //            if kcalTextField.text != "" {
    //                newIngredient.kcal = Int(kcalTextField.text!)
    //            }
    //            meal.append(newIngredient)
    //            print(newIngredient)
    //        } else {print("Enter ingredient name!")}
    
    
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        print("Now we need to change focus of the textfield...")
        if activeTextField == ingredientTextField! {
            ingredientTextField.resignFirstResponder()
            weightTextField.becomeFirstResponder()
        } else {
            kcalTextField.becomeFirstResponder()
        }
        
    }
    
}


//MARK: - UITextfield Delegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField != kcalTextField {
            textField.inputAccessoryView = toolbar }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        print("Yay!")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Saving data")
        return true
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
            cell.weightLabel.textColor = .black
        } else {
            cell.weightLabel.text = "гр"
            cell.weightLabel.textColor = .lightGray
        }
        if let kcal = meal[indexPath.row].kcal {
            cell.kcalLabel.text = "\(kcal)ккал/100гр"
            cell.kcalLabel.textColor = .black
        } else {
            cell.kcalLabel.text = "ккал/100гр"
            cell.kcalLabel.textColor = .lightGray
        }
        if let total = meal[indexPath.row].totalkCal {
            cell.totalKcalLabel.text = "\(total)ккал"
            cell.totalKcalLabel.textColor = .lightGray
        } else {
            cell.totalKcalLabel.text = "ккал"
        }
        return cell
    }
}



