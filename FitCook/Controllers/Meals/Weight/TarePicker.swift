import UIKit

class TarePickerVC: UIViewController {
	
	private var picker: UIPickerView!
	private var weightTextField: UITextField!
	private var kitchenWareTextField: UITextField!
	private var addButton: UIButton!
	private var tares: [Dish]?
	var coreData: CoreDataHelper?
	
	override func viewDidLoad() {
		buildWeightTextField()
		buildPicker()
		buildKitchenWareTextField()
		
	}
	
	func buildWeightTextField() {
		weightTextField = UITextField()
		weightTextField.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
		view.addSubview(weightTextField)
		weightTextField.placeholder = "Введите вес с посудой"
		weightTextField.textAlignment = .center
		weightTextField.keyboardType = .numberPad
		let toolbar = DoneToolbar()
		weightTextField.inputAccessoryView = toolbar
		weightTextField.becomeFirstResponder()
	}
	
	func buildKitchenWareTextField() {
		kitchenWareTextField = UITextField()
		kitchenWareTextField.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: 50)
		view.addSubview(kitchenWareTextField)
		kitchenWareTextField.placeholder = "Выберите посуду"
		kitchenWareTextField.textAlignment = .center
		kitchenWareTextField.inputView = picker
		let kitchenWareDictionaryButton = UIButton()
		kitchenWareDictionaryButton.translatesAutoresizingMaskIntoConstraints = false
		kitchenWareTextField.addSubview(kitchenWareDictionaryButton)
		kitchenWareDictionaryButton.tintColor = .black
		kitchenWareDictionaryButton.setImage(UIImage(systemName: "book"), for: .normal)
		kitchenWareDictionaryButton.trailingAnchor.constraint(equalTo: kitchenWareTextField.trailingAnchor).isActive = true
		kitchenWareDictionaryButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
		kitchenWareDictionaryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
		kitchenWareDictionaryButton.centerYAnchor.constraint(equalTo: kitchenWareTextField.centerYAnchor).isActive = true
		kitchenWareDictionaryButton.addTarget(self, action: #selector(kitchenWareDictionaryButtonPressed), for: .touchUpInside)
	}
	
	@objc func kitchenWareDictionaryButtonPressed() {
		print("Go to kitchenware")
	}
	
	func buildPicker() {
		picker = UIPickerView()
		
//		picker.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: 250)
//		view.addSubview(picker)
		picker.delegate = self
		picker.dataSource = self
		tares = coreData?.load()
	}
}

extension TarePickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return tares!.count
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let componentView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
		let label = UILabel(frame: CGRect(x: 0, y: 10, width: 300, height: 30))
		label.text = tares![row].name
		componentView.addSubview(label)
		return componentView
		
	}
}

