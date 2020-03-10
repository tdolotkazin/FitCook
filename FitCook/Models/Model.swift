import Foundation

func parseRecipe(_ string: String) -> (name: String, weight: Int64) {
	var recipe: (name: String, weight: Int64) = ("", 0)

	if let firstColon = string.firstIndex(of: ":") {
		recipe.name = String(string[..<firstColon]).trimmingCharacters(in: .whitespaces)
		let weightString = string[firstColon...]
		recipe.weight = Int64(weightString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
	} else {
		recipe.name = string.trimmingCharacters(in: .whitespaces)
	}
	return recipe
}



//func loadRecipeItems(in meal: Meal?) -> [RecipeItem] {
//	guard let meal = meal else {
//		fatalError("Unknown meal for ingredients list")
//	}
//	let request: NSFetchRequest<RecipeItem> = RecipeItem.fetchRequest()
//	let mealPredicate = NSPredicate(format: "inMeal == %@", meal)
//	request.predicate = mealPredicate
//	do {
//		let recipeItems = try context.fetch(request)
//		return recipeItems
//	} catch {
//		print("Error loading ingredients! \(error)")
//	}
//	return []
//}
//
//func loadResults(string: String) -> [Ingredient] {
//	var ingredients = [Ingredient]()
//	let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
//	let predicate = NSPredicate(format: "name CONTAINS %@", string)
//	request.predicate = predicate
//	do {
//		ingredients = try context.fetch(request)
//	} catch {
//		print("Error loading suggestions \(error)")
//	}
//	return ingredients
//}
//
//func loadAllIngredients() -> [Ingredient] {
//	var ingredients: [Ingredient] = []
//	let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
//	do {
//		ingredients = try context.fetch(request)
//	} catch {
//		print("Error loading ingredients \(error)")
//	}
//	return ingredients
//}
//
//func deleteIngredient(_ ingredient: Ingredient){
//		context.delete(ingredient)
//}
//
//func checkForExistingIngredient(string: String) -> Ingredient? {
//	let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
//	request.fetchLimit = 1
//	request.predicate = NSPredicate(format: "name == %@", string)
//	do {
//		let ingredient = try context.fetch(request).first
//		return ingredient
//	} catch {
//		fatalError("Error fetching data")
//	}
//}
//
////need to implement extra check for ":" in this method. Everything after this line should be weight. Just in case user wants to have name of ingredient with digits, e.g. "Cream of 20% fat"
////also need to implement regexp, so "Coconut Oil 100" should parse correctly
//
//func parseIngredient(string: String, meal: Meal) -> RecipeItem? {
//	if let ingredient = checkForExistingIngredient(string: string) {
//		if (ingredient.inRecipe?.intersects(meal.recipeItems as! Set<AnyHashable>))! {
//			return nil
//		} else {
//			let recipe = RecipeItem(context: context)
//			recipe.inMeal = meal
//			recipe.ingredient = ingredient
//			return recipe
//		}
//	} else {
//		let ingredient = Ingredient(context: context)
//		ingredient.name = string
//		let recipe = RecipeItem(context: context)
//		recipe.inMeal = meal
//		recipe.ingredient = ingredient
//		return recipe
//	}
//}
//
//func deleteRecipeItem(recipeItem: RecipeItem) {
//	if recipeItem.ingredient?.inRecipe?.count == 1 {
//		context.delete(recipeItem.ingredient!)
//	}
//	context.delete(recipeItem)
//}
//
func checkIfReadyForCalculation(ingredients: [RecipeItem], handler: (_ error: String) -> Void) -> Bool {
	for item in ingredients {
		if item.weight == 0 || item.ingredient!.kcal == 0 {
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

