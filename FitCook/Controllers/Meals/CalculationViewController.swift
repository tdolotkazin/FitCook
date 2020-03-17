import UIKit
import CoreData

class CalculationViewController: UIViewController {
	
	var coreData: CoreDataHelper?
	var activeTextField: UITextField?
	var meal: Meal?
	var ingredients = [RecipeItem]()
	var totalWeight: Int64 = 0
	var totalCalories: Int64 {
		get {
			var total: Int64 = 0
			for item in ingredients {
				total += item.ingredient!.kcal * item.weight / 100
			}
			return total
		}
	}
	var servings:Int64 = 6
	var servingWeight: Int64 { totalWeight / servings }
	var caloriesPerWeight: Int64 { totalCalories * 100 / totalWeight }
	var caloriesPerServing: Int64 { totalCalories / servings }
	var customServingWeight: Int64 = 0
	var customServingCalories: Int64 { customServingWeight * totalCalories / totalWeight }
	
	@IBOutlet weak var mealLabel: UILabel!
	@IBOutlet weak var totalWeightTextField: UITextField!
	@IBOutlet weak var totalCaloriesLabel: UILabel!
	@IBOutlet weak var caloriesPerWeightLabel: UILabel!
	@IBOutlet weak var servingsLabel: UILabel!
	@IBOutlet weak var servingStepper: UIStepper!
	@IBOutlet weak var servingCaloriesLabel: UILabel!
	@IBOutlet weak var servingWeightLabel: UILabel!
	@IBOutlet weak var customServingWeightTextField: UITextField!
	@IBOutlet weak var customServingCaloriesLabel: UILabel!
	
	@IBOutlet var toolbar: UIToolbar!
	override func viewDidLoad() {
		super.viewDidLoad()
		totalWeight = meal!.totalWeight
		if totalWeight == 0 {
			calcTotalWeight()
		}
		servingStepper.value = 6
		mealLabel.text = meal?.name
		updateView()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		coreData?.save()
	}
	
	@IBAction func servingsStepper(_ sender: UIStepper) {
		servings = Int64(sender.value)
		updateView()
	}
	
	func calcTotalWeight() {
		for item in ingredients {
			totalWeight += item.weight
		}
	}
	func updateView() {
		totalWeightTextField.text = String(totalWeight)
		totalCaloriesLabel.text = String(totalCalories)
		caloriesPerWeightLabel.text = String(caloriesPerWeight)
		servingsLabel.text = String(servings)
		servingCaloriesLabel.text = String(caloriesPerServing)
		servingWeightLabel.text = String(servingWeight)
		customServingCaloriesLabel.text = String(customServingCalories)
	}
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		meal?.totalWeight = totalWeight
		meal?.calPerWeight = caloriesPerWeight
		meal?.calPerServing = caloriesPerServing
		coreData?.save()
		activeTextField?.resignFirstResponder()
	}
}

extension CalculationViewController: UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		textField.inputAccessoryView = toolbar
		activeTextField = textField
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		guard textField.text != "" else {
			return false
		}
		switch textField.tag {
			case 1:
				totalWeight = Int64(textField.text!)!
				meal?.totalWeight = totalWeight
				updateView()
			case 2:
				customServingWeight = Int64(textField.text!)!
				updateView()
			default:
				print("Error")
		}
		coreData?.save()
		activeTextField = nil
		return true
	}
}
