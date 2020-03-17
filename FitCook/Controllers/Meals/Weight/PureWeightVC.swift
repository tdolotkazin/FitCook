import UIKit

class PureWeightVC: UIViewController, WeightChildView {
	
	var selectedItem: RecipeItem?
	
	@IBOutlet weak var pureWeightTextField: UITextField!
	
	override func viewDidLoad() {
		if let weight = selectedItem?.weight {
			pureWeightTextField.text = String(weight)
		}
	}
	
	
	func calculateWeight() -> Int64 {
	
			return Int64(pureWeightTextField.text!) ?? 0
	
	}
}
