import UIKit

class BeforeAfterVC: UIViewController, WeightChildView {

	var selectedItem: RecipeItem?
	
	@IBOutlet weak var beforeTextField: UITextField!
	
	@IBOutlet weak var afterTextField: UITextField!
	
	func calculateWeight() -> Int64 {
	
			let beforeWeight = Int64(beforeTextField.text ?? "0")!
			let afterWeight = Int64(afterTextField.text ?? "0")!
			return beforeWeight - afterWeight
	
	}
}
