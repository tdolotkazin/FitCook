//
//  Model.swift
//  FitCook
//
//  Created by Timur Dolotkazin on 03.03.2020.
//  Copyright © 2020 Timur Dolotkazin. All rights reserved.
//

import UIKit
import CoreData

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func save() {
	if context.hasChanges {
		do {
			try context.save()
		} catch {
			fatalError("Error saving CoreData \(error)")
		}
	}
}

func loadIngredients(in meal: Meal?, to ingredients: inout [Ingredient]) {
	guard let meal = meal else {
		fatalError("Unknown meal for ingredients list")
	}
	let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
	let mealPredicate = NSPredicate(format: "%@ IN inMeals", meal)
	request.predicate = mealPredicate
	do {
		ingredients = try context.fetch(request)
	} catch {
		print("Error loading ingredients! \(error)")
	}
}
func parseIngredient(string: String, meal: Meal) -> Ingredient {
	let name = string.components(separatedBy: ": ").first
	let newIngredient = Ingredient(context: context)
	newIngredient.name = name
	let weightString = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
	if let weight = Int(weightString) { newIngredient.weight = Int64(weight) }
	newIngredient.addToInMeals(meal)
	//need to implement extra check for ":" in this line. Everything after this line should be weight. Just in case user wants to have name of ingredient with digits, e.g. "Cream of 20% fat"
	//also need to implement regexp, so "Coconut Oil 100" should parse correctly
	save()
	return newIngredient
}

func deleteIngredient(ingredient: Ingredient) {
	context.delete(ingredient)
}

func checkIfReadyForCalculation(meal: Meal, ingredients: [Ingredient], handler: (_ error: String) -> Void) -> Bool {
	for item in ingredients {
		if item.weight == 0 || item.kcal == 0 {
			handler("Fill Ingredients")
			return false
		}
	}
	if ingredients.count == 0 {
		handler("Add Ingredients")
		return false
	}
	return true
}



