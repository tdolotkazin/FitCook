import UIKit

protocol CustomToolbarDelegate {
	func donePressed(toolbar: CustomToolbar)
	func nextPressed(toolbar: CustomToolbar)
	func weightPressed(toolbar: CustomToolbar)
}

enum CustomToolbarButton {
	case Done
	case Next
	case Weight
	case None
}

class CustomToolbar: UIToolbar {
	
	var buttonDelegate: CustomToolbarDelegate?
	
	
	init(leftButtonType: CustomToolbarButton = .None, rightButtonType: CustomToolbarButton) {
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
			case .Next:
				let nextText = NSLocalizedString("next", comment: "Next button in the toolbar")
				button = UIBarButtonItem(title: nextText, style: .plain, target: self, action: #selector(nextButtonPressed))
			case .Weight:
				let weightText = NSLocalizedString(": weight", comment: "Weight button in the toolbar")
				button = UIBarButtonItem(title: weightText, style: .plain, target: self, action:	#selector(weightButtonPressed))
//				button.title = weightText
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
		buttonDelegate?.donePressed(toolbar: self)
	}
	
	@objc func nextButtonPressed() {
		buttonDelegate?.nextPressed(toolbar: self)
	}
	
	@objc func weightButtonPressed() {
		buttonDelegate?.weightPressed(toolbar: self)
	}
}
