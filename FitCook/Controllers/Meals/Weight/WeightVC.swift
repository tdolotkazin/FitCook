import UIKit

class WeightVC: UIViewController {
	
	var coreData: CoreDataHelper?
	var delegate: WeightEnterDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let pickerVC = TarePickerVC()
		addChild(pickerVC)
		pickerVC.coreData = coreData
		pickerVC.delegate = self
		view.addSubview(pickerVC.view)
//		view.backgroundColor = .blue
	}
}

extension WeightVC: WeightEnterDelegate {
	func didUpdatedWeight(weight: Int64) {
		delegate?.didUpdatedWeight(weight: weight)
	}
	
	func didEndEnteringWeight() {
		delegate?.didEndEnteringWeight()
	}
}
