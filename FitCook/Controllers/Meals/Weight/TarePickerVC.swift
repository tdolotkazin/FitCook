import UIKit

class TarePickerVC: UIViewController {
	
	private var picker: UIPickerView!
	private var weightTextField: UITextField!
	private var kitchenWareTextField: UITextField!
	private var addButton: UIButton!
	private var tares: [Dish]?
	var coreData: CoreDataHelper?
	var delegate: WeightEnterDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		buildWeightTextField()
		buildPicker()
		buildKitchenWareTextField()
		buildKitchenWareDictionaryButton()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		weightTextField.becomeFirstResponder()
		updatePicker()
	}
	
	func buildWeightTextField() {
		weightTextField = UITextField()
		weightTextField.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
		view.addSubview(weightTextField)
		weightTextField.placeholder = "Введите вес с посудой"
		weightTextField.textAlignment = .center
		weightTextField.keyboardType = .numberPad
		let toolbar = CustomToolbar(rightButtonType: .Next)
		toolbar.buttonDelegate = self
		weightTextField.inputAccessoryView = toolbar
	}
	
	func buildKitchenWareTextField() {
		kitchenWareTextField = UITextField()
		kitchenWareTextField.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: 50)
		view.addSubview(kitchenWareTextField)
		kitchenWareTextField.placeholder = "Выберите посуду"
		kitchenWareTextField.textAlignment = .center
		kitchenWareTextField.inputView = picker
		let toolbar = CustomToolbar(rightButtonType: .Done)
		toolbar.buttonDelegate = self
		kitchenWareTextField.inputAccessoryView = toolbar
		
		
	}
	
	func buildKitchenWareDictionaryButton() {
		let kitchenWareDictionaryButton = UIButton()
		kitchenWareDictionaryButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(kitchenWareDictionaryButton)
		kitchenWareDictionaryButton.tintColor = .black
		kitchenWareDictionaryButton.setImage(UIImage(systemName: "book"), for: .normal)
		kitchenWareDictionaryButton.trailingAnchor.constraint(equalTo: kitchenWareTextField.trailingAnchor).isActive = true
		kitchenWareDictionaryButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
		kitchenWareDictionaryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
		kitchenWareDictionaryButton.centerYAnchor.constraint(equalTo: kitchenWareTextField.centerYAnchor).isActive = true
		kitchenWareDictionaryButton.addTarget(self, action: #selector(kitchenWareDictionaryButtonPressed), for: .touchUpInside)
	}
	
	@objc func kitchenWareDictionaryButtonPressed() {
		if let kitchenWareVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "kitchenwareVC") as? KitchenWareController {
			kitchenWareVC.coreData = coreData
			navigationController?.pushViewController(kitchenWareVC, animated: true)
		} else {
			fatalError("No Kitchenware Controller!")
		}
	}
	
	func buildPicker() {
		picker = UIPickerView()
		
		//		picker.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: 250)
		//		view.addSubview(picker)
		picker.delegate = self
		picker.dataSource = self
		tares = coreData?.load()
	}
	
	func updatePicker() {
		tares = coreData?.load()
		picker.reloadAllComponents()
	}
}

extension TarePickerVC: CustomToolbarDelegate {
	func donePressed(toolbar: CustomToolbar) {
		
		if let totalWeight = Int64(weightTextField.text!), let tareWeight = tares?[picker.selectedRow(inComponent: 0)].weight {
				let calculatedWeight = totalWeight - tareWeight > 0 ? totalWeight - tareWeight : 0
				delegate?.didUpdatedWeight(weight: calculatedWeight)
		}
		
		
		self.view.removeFromSuperview()
		self.removeFromParent()
		delegate?.didEndEnteringWeight()
	}
	
	func nextPressed(toolbar: CustomToolbar) {
		kitchenWareTextField.becomeFirstResponder()
	}
	
	func weightPressed(toolbar: CustomToolbar) {
		
	}
	
	
}

extension TarePickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return tares!.count != 0 ? tares!.count : 1
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let componentView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
		let label = UILabel(frame: CGRect(x: 0, y: 10, width: 300, height: 30))
		if tares?.count == 0 {
			label.text = "Добавьте посуду"
		} else {
			label.text = "\(tares![row].name!) - \(tares![row].weight)гр."
		}
		componentView.addSubview(label)
		return componentView
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if tares?.count != 0 {
			if let totalWeight = Int64(weightTextField.text!), let tareWeight = tares?[row].weight {
				let calculatedWeight = totalWeight - tareWeight > 0 ? totalWeight - tareWeight : 0
				delegate?.didUpdatedWeight(weight: calculatedWeight)
			}
		}
	}
}

