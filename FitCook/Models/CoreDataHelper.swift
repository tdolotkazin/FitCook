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
			fatalError("Can't load data: \(error)")
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
		let newRecipeItem: RecipeItem = create()
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
			delete(recipeItem.ingredient!)
		}
		delete(recipeItem)
		save()
	}
	
	func loadSearchResults<T: NSManagedObject>(string: String) -> [T] {
		var results = [T]()
		if let request = T.fetchRequest() as? NSFetchRequest<T> {
			let predicate = NSPredicate(format: "name CONTAINS %@", string)
			request.predicate = predicate
			do {
				results = try context.fetch(request)
			} catch {
				print("Error loading suggestions \(error)")
			}
			return results
		} else {
			fatalError("request is nil!")
		}
	}
}
