import UIKit

protocol DoneToolbarDelegate {
	func doneButtonPressed()
}

class DoneToolbar: UIToolbar {
	
	var buttonDelegate: DoneToolbarDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
		items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
				 UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))]
		translatesAutoresizingMaskIntoConstraints = false
		contentMode = .scaleAspectFit
	
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func doneButtonPressed() {
		buttonDelegate?.doneButtonPressed()
	}
}
