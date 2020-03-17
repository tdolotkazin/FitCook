import UIKit
import CoreData

class CoreDataHelper {
	
	let context: NSManagedObjectContext = {
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores { (persistentStoreDescription, error) in
			if let error = error as NSError? {
				fatalError("Error in initializing Core Data \(error)")
			}
		}
		return container.viewContext
	}()
	
	func save() {
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				fatalError("Can't save context: \(error)")
			}
		}
	}
	
	func create<T: NSManagedObject>(named name: String) -> T {
		let newObject = T(context: context)
		newObject.setValue(name, forKey: "name")
		save()
		return newObject
	}
	
	func create<T: NSManagedObject>() -> T {
		return T(context: context)
	}
	
	func load<T: NSManagedObject>() -> [T] {
		let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
		do {
			return try context.fetch(request)
		} catch {
			fatalError("Can't fetch meals \(error)")
		}
	}
	
	func delete<T: NSManagedObject>(_ object: T) {
		context.delete(object)
		save()
	}
	
	private func checkIfExists<T: NSManagedObject>(_ entityName: String, named name: String) -> T? {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		let predicate = NSPredicate(format: "name == %@", name)
		request.predicate = predicate
		request.fetchLimit = 1
		do {
			let existingItem = try context.fetch(request).first
			return existingItem as? T
		} catch {
			fatalError("Error in checkIfExists method \(error)")
		}
	}
	
	func addRecipeItem(from string: String, to recipeItems: inout [RecipeItem]) -> RecipeItem? {
		let parsedRecipeItem = parseRecipe(string)
		if recipeItems.contains(where: { (recipeItem) -> Bool in
			recipeItem.ingredient?.name == parsedRecipeItem.name
		}) {
			return nil //in case there's already a recipeItem with this name
		}
		let newRecipeItem:RecipeItem = create()
		if let ingredient = checkIfExists("Ingredient", named: parsedRecipeItem.name) {
			newRecipeItem.ingredient = (ingredient as! Ingredient)
		} else {
			let newIngredient: Ingredient = (create(named: parsedRecipeItem.name))
			newRecipeItem.ingredient = newIngredient
		}
		newRecipeItem.weight = parsedRecipeItem.weight
		return newRecipeItem
	}
	
	func deleteRecipeItem(recipeItem: RecipeItem) {
		if recipeItem.ingredient?.inRecipe?.count == 1 {
			//MARK: - IMPORTANT! BUG!
			//If user deletes meal, then recipes are deleted as cascade
			//After that user can delete ingredients in ingredient list.
			//Maybe I need to make it not so easy...
			//Not in swipe or something...
			//Or just ingredients need to be hard to find, not in tab bar view.
			delete(recipeItem.ingredient!)
		}
		delete(recipeItem)
		save()
	}
	
	func loadSearchResults(string: String) -> [Ingredient] {
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
	
}
