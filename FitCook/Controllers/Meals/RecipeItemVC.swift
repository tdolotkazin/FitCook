import UIKit

class RecipeItemVC: UIViewController, UITextFieldDelegate {
	
	var recipeItem: RecipeItem!
	var coreData: CoreDataHelper?
	private var weight: Int64?
	private var constraints: [NSLayoutConstraint]!
	private var hiddenConstraints: [NSLayoutConstraint]!
	private var segmentedControl: UISegmentedControl!
	private var toolbar: CustomToolbar!
	private var weightView: UIView?
	
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
		itemNameLabel.text = recipeItem.ingredient!.name
		weightTextField.text = recipeItem.weight != 0 ? String(recipeItem.weight) : ""
		kcalTextField.text = recipeItem.ingredient!.kcal != 0 ? String(recipeItem.ingredient!.kcal) : ""
		weightTextField.delegate = self
		kcalTextField.delegate = self
		toolbar = CustomToolbar(leftButtonType: .None, rightButtonType: .Done)
		toolbar.buttonDelegate = self
		updateTotalKcalLabel()
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.keyboardType = .numberPad
		textField.inputAccessoryView = toolbar
		if textField == weightTextField {
			beginEnteringWeight()
		}
	}
	
	func beginEnteringWeight() {
		UIView.animate(withDuration: 0.3, animations: {
			NSLayoutConstraint.deactivate(self.constraints)
			NSLayoutConstraint.activate(self.hiddenConstraints)
			self.view.layoutIfNeeded()
			self.view.addSubview(self.segmentedControl)
		})
		
		weightView = UIView(frame: CGRect.zero)
		weightView?.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(weightView!)
		weightView?.topAnchor.constraint(equalTo: weightTextField.bottomAnchor).isActive = true
		weightView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		weightView?.heightAnchor.constraint(equalToConstant: 230).isActive = true
		segmentedAction(segmentedControl)
	}
	
	func endEnteringWeight() {
		UIView.animate(withDuration: 0.3) {
			NSLayoutConstraint.deactivate(self.hiddenConstraints)
			NSLayoutConstraint.activate(self.constraints)
			self.view.layoutIfNeeded()
			self.segmentedControl.removeFromSuperview()
		}
		weightView?.removeFromSuperview()
		weightView = nil
	}
	
	func createSegmentedControl() {
		let items = ["Чистый вес", "Вес с тарой", "Вес до/после"]
		segmentedControl = UISegmentedControl(items: items)
		segmentedControl.frame = CGRect(x: 13, y: 420, width: 343, height: 32)
		segmentedControl.selectedSegmentIndex = 0
		segmentedControl.addTarget(self, action: #selector(segmentedAction), for: .valueChanged)
	}
	
	@objc func segmentedAction(_ control: UISegmentedControl) {
		for view in weightView!.subviews {
			view.removeFromSuperview()
		}
		
		switch control.selectedSegmentIndex {
			case 0:
				showPureWeightView()
			case 1:
				showPickerView()
			case 2:
				showBeforeAfterView()
			default:
				fatalError("Unknown segmented control segment!")
		}
	}
	
	func showPureWeightView() {
		let pureView = UIView()
		pureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		pureView.backgroundColor = .red
		pureView.alpha = 0.5
		weightView?.addSubview(pureView)
		weightTextField.placeholder = "Введите вес"
		weightTextField.becomeFirstResponder()
	}
	
	func showPickerView() {
		let pickerVC = TarePickerVC()
		addChild(pickerVC)
		pickerVC.coreData = coreData
		pickerVC.delegate = self
		weightView?.addSubview(pickerVC.view)
		weightTextField.placeholder = "Вводите ниже, я посчитаю"
	}
	
	func showBeforeAfterView() {
		let beforeAfterVC = BeforeAfterVC()
		addChild(beforeAfterVC)
		weightView?.addSubview(beforeAfterVC.view)
		beforeAfterVC.delegate = self
		weightTextField.placeholder = "Вводите ниже, я посчитаю"
	}
	
	func updateTotalKcalLabel() {
		if recipeItem.weight != 0 && recipeItem.ingredient?.kcal != 0 {
			totalKcalLabel.text = String(recipeItem.weight * recipeItem.ingredient!.kcal / 100)
		}
	}
}

//MARK: - Weight calculation delegate methods

extension RecipeItemVC: WeightEnterDelegate {
	func didUpdatedWeight(weight: Int64) {
		self.weight = weight
		weightTextField.text = String(weight)
	}
	
	func didEndEnteringWeight() {
		recipeItem?.weight = weight ?? 0
		endEnteringWeight()
	}
}

//MARK: - Done Toolbar delegate methods

extension RecipeItemVC: CustomToolbarDelegate {
	func weightPressed(toolbar: CustomToolbar) {
		
	}
	
	func nextPressed(toolbar: CustomToolbar) {
		
	}
	
	func donePressed(toolbar: CustomToolbar) {
		if weightTextField.isEditing {
			if let weight = Int64(weightTextField.text!) {
				recipeItem.weight = weight
			}
			endEnteringWeight()
			weightTextField.resignFirstResponder()
		} else if kcalTextField.isEditing {
			if let kcal = Int64(kcalTextField.text!) {
				recipeItem.ingredient?.kcal = kcal
			}
			kcalTextField.resignFirstResponder()
		}
		updateTotalKcalLabel()
	}
}
