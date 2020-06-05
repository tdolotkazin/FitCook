import UIKit
import CoreData

class CalculationVC: UIViewController {
	
	var coreData: CoreDataHelper?
	var meal: Meal!
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
	var weightVC: WeightVC?
	
	@IBOutlet weak var totalWeightTextField: UITextField!
	@IBOutlet weak var totalCaloriesLabel: UILabel!
	@IBOutlet weak var servingsLabel: UILabel!
	@IBOutlet weak var servingCaloriesLabel: UILabel!
	@IBOutlet weak var customServingWeightTextField: UITextField!
	@IBOutlet weak var customServingCaloriesLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		totalWeight = meal.totalWeight
		if totalWeight == 0 {
			totalWeight = meal.calcWeight()
		}
		servings = 6
		title = meal?.name
		updateView()
		totalWeightTextField.delegate = self
		customServingWeightTextField.delegate = self
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		meal.calPerServing = caloriesPerServing
		coreData?.save()
	}
	
	@IBAction func buttonPressed(_ sender: UIButton) {
		switch sender.tag {
			case 0:
				if servings != Settings.maxServings {
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
		
	func updateView() {
		totalWeightTextField.text = String(totalWeight)
		totalCaloriesLabel.text = String(totalCalories)
		servingsLabel.text = String(servings)
		servingCaloriesLabel.text = String(caloriesPerServing)
		customServingCaloriesLabel.text = String(customServingCalories)
	}
}

extension CalculationVC: WeightEnterDelegate {
	func beginEnteringWeight() {
		for subview in view.subviews {
			if subview.tag != 1 {
				subview.isHidden = true
			}
		}
		weightVC = WeightVC()
		weightVC?.coreData = coreData
		weightVC?.delegate = self
		addChild(weightVC!)
		weightVC!.didMove(toParent: self)
		view.addSubview(weightVC!.view)
		weightVC?.view.translatesAutoresizingMaskIntoConstraints = false
		weightVC?.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
		weightVC?.view.heightAnchor.constraint(equalToConstant: 260).isActive = true
		weightVC?.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
	}
	
	func endEnteringWeight() {
		for subview in view.subviews {
			subview.isHidden = false
		}
		weightVC?.view.removeFromSuperview()
		weightVC?.removeFromParent()
		weightVC = nil
	}
	
	func didUpdatedWeight(weight: Int64) {
		totalWeightTextField.text = String(weight)
		meal?.totalWeight = weight
	}
	
	func didEndEnteringWeight() {
		endEnteringWeight()
		coreData?.save()
	}
	
}


extension CalculationVC: UITextFieldDelegate {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		let toolbar = CustomToolbar(rightButtonType: .Done)
		toolbar.buttonDelegate = self
		textField.inputAccessoryView = toolbar
		textField.keyboardType = .numberPad
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == totalWeightTextField {
			beginEnteringWeight()
		}
	}
	
//	func textFieldDidEndEditing(_ textField: UITextField) {
//		if textField == totalWeightTextField {
//			endEnteringWeight()
//		}
//	}
	
}

extension CalculationVC: CustomToolbarDelegate {
	func donePressed(toolbar: CustomToolbar) {
		if totalWeightTextField.isEditing {
			if let weight = Int64(totalWeightTextField.text!) {
				meal?.totalWeight = weight
				meal?.calPerServing = caloriesPerServing
				updateView()
				totalWeightTextField.endEditing(false)
			}
		} else if customServingWeightTextField.isEditing {
			if let customWeight = Int64(customServingWeightTextField.text!) {
				customServingWeight = customWeight
				updateView()
				
			}
			customServingWeightTextField.endEditing(false)
		}
	}
	
	func nextPressed(toolbar: CustomToolbar) {
		
	}
	
	func weightPressed(toolbar: CustomToolbar) {
		
	}
}
