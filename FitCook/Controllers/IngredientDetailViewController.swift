//
//  IngredientDetailViewController.swift
//  FitCook
//
//  Created by Timur Dolotkazin on 03.03.2020.
//  Copyright © 2020 Timur Dolotkazin. All rights reserved.
//

import UIKit

class IngredientDetailViewController: UIViewController {
	var selectedIngredient: Ingredient?
	
	
	@IBOutlet weak var weightTextField: UITextField!
	@IBOutlet weak var kcalTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = selectedIngredient?.name
		if let weight = selectedIngredient?.weight {
			weightTextField.text = "\(weight)"
		}
		if let kcal = selectedIngredient?.kcal {
			kcalTextField.text = "\(kcal)"
		}
	}
		
	@IBAction func saveButtonPressed(_ sender: UIButton) {
		selectedIngredient?.weight = Int(weightTextField.text ?? "0")
		selectedIngredient?.kcal = Int(kcalTextField.text ?? "0")
		self.navigationController?.popViewController(animated: true)
	}
}
