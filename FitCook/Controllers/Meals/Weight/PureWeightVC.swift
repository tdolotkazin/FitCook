import UIKit

class PureWeightVC: UIViewController, WeightChildView {

	@IBOutlet weak var pureWeightTextField: UITextField!
	
	func calculateWeight() -> Int64 {
		return Int64(pureWeightTextField.text!) ?? 0
	}
}
