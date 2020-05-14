import UIKit

class TarePickerVC: UIViewController {
	
	private var picker: UIPickerView!
	private var textfield: UITextField!
	private var addButton: UIButton!
	private var tares: [Dish]?
	var coreData: CoreDataHelper?
	
	override func viewDidLoad() {
		textfield = UITextField()
		textfield.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
		view.addSubview(textfield)
		textfield.placeholder = "Введите вес с тарой"
		textfield.textAlignment = .center
		textfield.keyboardType = .numberPad
		let toolbar = DoneToolbar()
		textfield.inputAccessoryView = toolbar
		textfield.becomeFirstResponder()
		picker = UIPickerView()
		picker.frame = CGRect(x: 0, y: 50, width: view.bounds.width, height: 200)
		view.addSubview(picker)
		picker.delegate = self
		picker.dataSource = self
		tares = coreData?.load()
		addButton = UIButton(type: .roundedRect)
		view.addSubview(addButton)
		addButton.translatesAutoresizingMaskIntoConstraints = false
		addButton.frame.size = CGSize(width: 150, height: 50)
		addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		addButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 10).isActive = true
		addButton.setTitle("Добавить посуду", for: .normal)
		addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
	}
	
	@objc func addButtonPressed() {
		print("Add button pressed")
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
		let componentView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
		let label = UILabel(frame: CGRect(x: 0, y: 10, width: 300, height: 30))
		label.text = tares![row].name
		componentView.addSubview(label)
		return componentView
	}
	
}
