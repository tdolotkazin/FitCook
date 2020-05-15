import UIKit

protocol CustomToolbarDelegate {
	func donePressed()
	func nextPressed()
	func weightPressed()
}

enum CustomToolbarButton {
	case Done
	case Next
	case Weight
	case None
}

class CustomToolbar: UIToolbar {
	
	var buttonDelegate: CustomToolbarDelegate?
	
	
	init(leftButtonType: CustomToolbarButton, rightButtonType: CustomToolbarButton) {
		super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
		let leftButton = createButton(buttonType: leftButtonType)
		let rightButton = createButton(buttonType: rightButtonType)
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		items = [leftButton, flexibleSpace, rightButton]
	}
	
	func createButton(buttonType: CustomToolbarButton) -> UIBarButtonItem {
		let button: UIBarButtonItem
		switch buttonType {
			case .Done: button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
			case .Next: button = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonPressed))
			case .Weight: button = UIBarButtonItem(title: ": weight", style: .plain, target: self, action:	#selector(weightButtonPressed))
			button.title = ": weight"
			case .None: button = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		}
		return button
	}
	
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
		buttonDelegate?.donePressed()
	}
	
	@objc func nextButtonPressed() {
		buttonDelegate?.nextPressed()
	}
	
	@objc func weightButtonPressed() {
		buttonDelegate?.weightPressed()
	}
}
