import UIKit
import CoreData

class CalculationVC: UIViewController {
	
	var coreData: CoreDataHelper?
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
	@IBOutlet weak var servingsLabel: UILabel!
	@IBOutlet weak var servingCaloriesLabel: UILabel!
	@IBOutlet weak var customServingWeightTextField: UITextField!
	@IBOutlet weak var customServingCaloriesLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		totalWeight = meal!.totalWeight
		if totalWeight == 0 {
			calcTotalWeight()
		}
		servings = 6
		title = meal?.name
		updateView()
		totalWeightTextField.delegate = self
		customServingWeightTextField.delegate = self
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		coreData?.save()
	}
	
	@IBAction func buttonPressed(_ sender: UIButton) {
		switch sender.tag {
			case 0:
				if servings != 20 {
					servings += 1
			}
			case 1:
				if servings != 1 {
					servings -= 1
			}
			default:
				fatalError("Unknown button in calculation VC")
		}
		meal?.calPerServing = caloriesPerServing
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
		servingsLabel.text = String(servings)
		servingCaloriesLabel.text = String(caloriesPerServing)
		customServingCaloriesLabel.text = String(customServingCalories)
	}
	
	//	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
	//		meal?.totalWeight = totalWeight
	//		meal?.calPerWeight = caloriesPerWeight
	//		meal?.calPerServing = caloriesPerServing
	//		activeTextField?.resignFirstResponder()
	//	}
}

extension CalculationVC: UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		let toolbar = CustomToolbar(rightButtonType: .Done)
		toolbar.buttonDelegate = self
		textField.inputAccessoryView = toolbar
		textField.keyboardType = .numberPad
		return true
	}
	
//	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//		guard textField.text != "" else {
//			return false
//		}
//		switch textField.tag {
//			case 1:
//				totalWeight = Int64(textField.text!)!
//				meal?.totalWeight = totalWeight
//				updateView()
//			case 2:
//				customServingWeight = Int64(textField.text!)!
//				updateView()
//			default:
//				print("Error")
//		}
//		coreData?.save()
//		return true
//	}
}

extension CalculationVC: CustomToolbarDelegate {
	func donePressed(toolbar: CustomToolbar) {
		if totalWeightTextField.isEditing {
			if let weight = Int64(totalWeightTextField.text!) {
				meal?.totalWeight = weight
				updateView()
				totalWeightTextField.endEditing(false)
			}
		} else if customServingWeightTextField.isEditing {
			if let customWeight = Int64(customServingWeightTextField.text!) {
				customServingWeight = customWeight
				updateView()
				customServingWeightTextField.endEditing(false)
			}
		}
	}
	
	func nextPressed(toolbar: CustomToolbar) {
		
	}
	
	func weightPressed(toolbar: CustomToolbar) {
		
	}
}
