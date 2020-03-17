import UIKit

protocol KitchenWareDetailDelegate {
	func detailViewDismisseed()
}

class KitchenWareDetailViewController: UIViewController {
	var coreData: CoreDataHelper?
	var dish: Dish?
	var delegate: KitchenWareDetailDelegate?
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var weightTextField: UITextField!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		nameTextField.text = dish?.name
		nameTextField.autocorrectionType = .no
		weightTextField.text = String(dish!.weight)
		if let imageData = dish?.image {
			image.image = UIImage(data: imageData)
		} else {
			image.image = UIImage(systemName: "camera")
		}
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
