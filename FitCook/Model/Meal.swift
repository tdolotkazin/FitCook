import Foundation

extension Meal {
	func calcWeight() -> Int64 {
		var totalWeight: Int64 = 0
		for recipeItem in self.recipeItems! {
			totalWeight += (recipeItem as AnyObject).weight
		}
		return totalWeight
	}
	
	func getRecipeItems() -> [RecipeItem] {
		return self.recipeItems?.allObjects as! [RecipeItem]
	}
	
}
