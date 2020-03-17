import UIKit

class TareVC: UIViewController, WeightChildView {
	
	var coreData: CoreDataHelper?
	var kitchenWare: [Dish]?
	var selectedItem: RecipeItem?
	
	lazy var weight: Int64 = calculateWeight()
	

	@IBOutlet weak var tareWeightTextField: UITextField!
	
	@IBOutlet weak var tarePickerView: UIPickerView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		kitchenWare = coreData?.load()
    }

	func calculateWeight() -> Int64 {
		let totalWeight = Int64(tareWeightTextField.text!) ?? 0
		let selectedTareRow = tarePickerView.selectedRow(inComponent: 0)
		let tareWeight = kitchenWare![selectedTareRow].weight
		return totalWeight - tareWeight
	}
}

//MARK: - Picker View Methods

extension TareVC: UIPickerViewDataSource, UIPickerViewDelegate {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return kitchenWare?.count ?? 0
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return "\(kitchenWare![row].name!) - \(kitchenWare![row].weight)гр."
	}
	
}
