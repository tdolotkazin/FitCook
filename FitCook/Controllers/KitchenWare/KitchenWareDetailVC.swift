import UIKit

protocol KitchenWareDetailDelegate {
	func detailViewDismisseed()
}

class KitchenWareDetailVC: UIViewController {
	var coreData: CoreDataHelper?
	var dish: Dish?
	var delegate: KitchenWareDetailDelegate?
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var weightTextField: UITextField!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		nameTextField.text = dish?.name
		nameTextField.autocorrectionType = .no
		weightTextField.text = String(dish!.weight)
    }
	
	@IBAction func saveButtonPressed(_ sender: UIButton) {
		dish?.weight = Int64(weightTextField.text!) ?? 0
		dish?.name = nameTextField.text
		coreData?.save()
		weightTextField.resignFirstResponder()
		delegate?.detailViewDismisseed()
		self.dismiss(animated: true, completion: nil)
	}
}
