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

