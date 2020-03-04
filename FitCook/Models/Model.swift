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


//change inout to returning an array!
func loadRecipeItems(in meal: Meal?) -> [RecipeItem] {
	guard let meal = meal else {
		fatalError("Unknown meal for ingredients list")
	}
	let request: NSFetchRequest<RecipeItem> = RecipeItem.fetchRequest()
	let mealPredicate = NSPredicate(format: "inMeal == %@", meal)
	request.predicate = mealPredicate
	do {
		let recipeItems = try context.fetch(request)
		return recipeItems
	} catch {
		print("Error loading ingredients! \(error)")
	}
	return []
}

func loadResults(string: String) -> [Ingredient] {
	var ingredients = [Ingredient]()
	let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
	let predicate = NSPredicate(format: "name CONTAINS %@", string)
	request.predicate = predicate
	do {
		ingredients = try context.fetch(request)
	} catch {
		print("Error loading suggestions \(error)")
	}
	return ingredients
}

func checkForExistingIngredient(string: String) -> Ingredient? {
	let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
	request.fetchLimit = 1
	request.predicate = NSPredicate(format: "name == %@", string)
	do {
		let ingredient = try context.fetch(request).first
		return ingredient
	} catch {
		fatalError("Error fetching data")
	}
}

//need to implement extra check for ":" in this method. Everything after this line should be weight. Just in case user wants to have name of ingredient with digits, e.g. "Cream of 20% fat"
//also need to implement regexp, so "Coconut Oil 100" should parse correctly

func parseIngredient(string: String, meal: Meal) -> RecipeItem? {
	if let ingredient = checkForExistingIngredient(string: string) {
		if (ingredient.inRecipe?.intersects(meal.recipeItems as! Set<AnyHashable>))! {
			return nil
		} else {
			let recipe = RecipeItem(context: context)
			recipe.inMeal = meal
			recipe.ingredient = ingredient
			return recipe
		}
	} else {
		let ingredient = Ingredient(context: context)
		ingredient.name = string
		let recipe = RecipeItem(context: context)
		recipe.inMeal = meal
		recipe.ingredient = ingredient
		return recipe
	}
}

func deleteRecipeItem(recipeItem: RecipeItem) {
	if recipeItem.ingredient?.inRecipe?.count == 1 {
		context.delete(recipeItem.ingredient!)
	}
	context.delete(recipeItem)
}

func checkIfReadyForCalculation(meal: Meal, ingredients: [RecipeItem], handler: (_ error: String) -> Void) -> Bool {
//	for item in ingredients {
//		if item.weight == 0 || item.kcal == 0 {
//			handler("Fill Ingredients")
//			return false
//		}
//	}
//	if ingredients.count == 0 {
//		handler("Add Ingredients")
//		return false
//	}
	return true
}



