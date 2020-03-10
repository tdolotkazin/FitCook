import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var calPerServing: Int64
    @NSManaged public var calPerWeight: Int64
    @NSManaged public var name: String?
    @NSManaged public var totalWeight: Int64
    @NSManaged public var recipeItems: Set<RecipeItem>?

}

// MARK: Generated accessors for recipeItems
extension Meal {

    @objc(addRecipeItemsObject:)
    @NSManaged public func addToRecipeItems(_ value: RecipeItem)

    @objc(removeRecipeItemsObject:)
    @NSManaged public func removeFromRecipeItems(_ value: RecipeItem)

    @objc(addRecipeItems:)
    @NSManaged public func addToRecipeItems(_ values: NSSet)

    @objc(removeRecipeItems:)
    @NSManaged public func removeFromRecipeItems(_ values: NSSet)

}
