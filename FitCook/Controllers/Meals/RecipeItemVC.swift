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
	private var isEnteringWeight = false
	
	@IBOutlet weak var itemNameLabel: UILabel!
	@IBOutlet weak var weightTextField: UITextField!
	@IBOutlet weak var kcalTextField: UITextField!
	@IBOutlet weak var totalKcalLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
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
	
	@objc func keyboardWillShow(_ notification: Notification) {
		
		if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			let keyboardHeight = keyboardRect.height
			if isEnteringWeight {
				if segmentedControl == nil {
					createSegmentedControl(bottom: keyboardHeight)
				}
			}
		}
	}
	
	func beginEnteringWeight() {
		UIView.animate(withDuration: 0.3, animations: {
			NSLayoutConstraint.deactivate(self.constraints)
			NSLayoutConstraint.activate(self.hiddenConstraints)
			self.view.layoutIfNeeded()
		})
		weightView = UIView(frame: CGRect.zero)
		weightView?.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(weightView!)
		weightView?.topAnchor.constraint(equalTo: weightTextField.bottomAnchor).isActive = true
		weightView?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		weightView?.heightAnchor.constraint(equalToConstant: 180).isActive = true
//		segmentedAction(segmentedControl)
		isEnteringWeight = true
	}
	
	func endEnteringWeight() {
		UIView.animate(withDuration: 0.3) {
			NSLayoutConstraint.deactivate(self.hiddenConstraints)
			NSLayoutConstraint.activate(self.constraints)
			self.view.layoutIfNeeded()
			
		}
		weightView?.removeFromSuperview()
		weightView = nil
		segmentedControl.removeFromSuperview()
		segmentedControl = nil
		isEnteringWeight = false
	}
	
	func createSegmentedControl(bottom: CGFloat) {
		let items = ["Чистый вес", "Вес с тарой", "Вес до/после"]
		segmentedControl = UISegmentedControl(items: items)
		view.addSubview(segmentedControl)
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
		segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
		segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
		segmentedControl.heightAnchor.constraint(equalToConstant: 30),
		segmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom - 12)
		])
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
		if let weight = Int64(weightTextField.text!) {
			recipeItem.weight = weight
		}
		if let kcal = Int64(kcalTextField.text!) {
			recipeItem.ingredient?.kcal = kcal
		}
		updateTotalKcalLabel()
	}
}

//MARK: - Done Toolbar delegate methods

extension RecipeItemVC: CustomToolbarDelegate {
	func weightPressed(toolbar: CustomToolbar) {
		
	}
	
	func nextPressed(toolbar: CustomToolbar) {
		
	}
	
	func donePressed(toolbar: CustomToolbar) {
		if let weight = Int64(weightTextField.text!) {
			recipeItem.weight = weight
		}
		if let kcal = Int64(kcalTextField.text!) {
			recipeItem.ingredient?.kcal = kcal
		}
		if weightTextField.isEditing {
			endEnteringWeight()
			weightTextField.resignFirstResponder()
		} else if kcalTextField.isEditing {
			kcalTextField.resignFirstResponder()
		}
	updateTotalKcalLabel()
	
	}
}
