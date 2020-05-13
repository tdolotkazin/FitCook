import UIKit

class TarePicker: UIView {
	
	var picker: UIPickerView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		picker = UIPickerView()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
