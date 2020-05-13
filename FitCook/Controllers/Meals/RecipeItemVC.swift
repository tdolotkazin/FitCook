import UIKit

class RecipeItemVC: UIViewController, UITextFieldDelegate {
	
	var selectedRecipeItem: RecipeItem?
	var coreData: CoreDataHelper?
	var weight: Int64?
	var constraints: [NSLayoutConstraint]!
	var hiddenConstraints: [NSLayoutConstraint]!
	var segmentedControl: UISegmentedControl!
	
	@IBOutlet weak var itemNameLabel: UILabel!
	@IBOutlet weak var weightTextField: UITextField!
	@IBOutlet weak var kcalTextField: UITextField!
	@IBOutlet weak var totalKcalLabel: UILabel!

	
	override func viewDidLoad() {
		super.viewDidLoad()
		createSegmentedControl()
		constraints = [
			itemNameLabel.heightAnchor.constraint(equalToConstant: 80),
			kcalTextField.heightAnchor.constraint(equalToConstant: 80),
			totalKcalLabel.heightAnchor.constraint(equalToConstant: 80)]
		hiddenConstraints = [
			itemNameLabel.heightAnchor.constraint(equalToConstant: 0),
			kcalTextField.heightAnchor.constraint(equalToConstant: 0),
			totalKcalLabel.heightAnchor.constraint(equalToConstant: 0)]
		NSLayoutConstraint.deactivate(hiddenConstraints)
		NSLayoutConstraint.activate(constraints)
		itemNameLabel.text = selectedRecipeItem?.ingredient!.name
		weightTextField.delegate = self
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.keyboardType = .numberPad
		beginEnteringWeight()
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {

	}
	

	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		weightTextField.resignFirstResponder()
	}
	
	func beginEnteringWeight() {
		UIView.animate(withDuration: 0.3, animations: {
			NSLayoutConstraint.deactivate(self.constraints)
			NSLayoutConstraint.activate(self.hiddenConstraints)
			self.view.layoutIfNeeded()
			self.view.addSubview(self.segmentedControl)
		})
	}
	
	func endEnteringWeight() {
		UIView.animate(withDuration: 0.3) {
			NSLayoutConstraint.deactivate(self.hiddenConstraints)
			NSLayoutConstraint.activate(self.constraints)
			self.view.layoutIfNeeded()
			self.segmentedControl.removeFromSuperview()
		}
	}
	
	func createSegmentedControl() {
		let items = ["Чистый вес", "Вес с тарой", "Вес до/после"]
		segmentedControl = UISegmentedControl(items: items)
		segmentedControl.frame = CGRect(x: 13, y: 380, width: 343, height: 32)
		segmentedControl.selectedSegmentIndex = 0
		segmentedControl.addTarget(self, action: #selector(segmentedAction), for: .valueChanged)
	}
	
	@objc func segmentedAction(_ control: UISegmentedControl) {
		switch control.selectedSegmentIndex {
			case 0:
				print("1 is selected")
			case 1:
				print("2 is selected")
			case 2:
				showBeforeAfterView()
			default:
				fatalError("Unknown segmented control segment!")
		}
	}
	func showPickerView() {
		
	}
	
	func showBeforeAfterView() {
		let beforeAfterVC = BeforeAfterVC()
		self.addChild(beforeAfterVC)
		let BAView = UIView(frame: CGRect(x: 0, y: 80, width: 375, height: 100))
		view.addSubview(BAView)
		BAView.addSubview(beforeAfterVC.view)
		beforeAfterVC.delegate = self
	}
}

extension RecipeItemVC: WeightEnterDelegate {
	func didUpdatedWeight(weight: Int64) {
		self.weight = weight
		weightTextField.text = String(weight)
	}
	
	func didEndEnteringWeight() {
		endEnteringWeight()
	}
}

