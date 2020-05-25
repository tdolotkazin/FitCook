//
//  MealCell.swift
//  FitCook
//
//  Created by Timur Dolotkazin on 31.03.2020.
//  Copyright © 2020 Timur Dolotkazin. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {

	@IBOutlet weak var mealNameLabel: UILabel!
	@IBOutlet weak var servingCaloriesLabel: UILabel!
	
	func configureCell(meal: Meal) {
		mealNameLabel.text = meal.name
		servingCaloriesLabel.text = meal.calPerServing != 0 ? String(meal.calPerServing) : ""
	}
    
}
