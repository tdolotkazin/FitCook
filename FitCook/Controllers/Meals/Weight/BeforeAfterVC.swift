import UIKit

protocol WeightEnterDelegate {
	func didUpdatedWeight(weight: Int64)
	func didEndEnteringWeight()
}

class BeforeAfterVC: UIViewController, UITextFieldDelegate {
	
	var weightBefore:Int64 = 0
	var weightAfter:Int64 = 0
	var beforeTextField: UITextField!
	var afterTextField: UITextField!
	var toolbar: CustomToolbar?
	var delegate: WeightEnterDelegate?
	
	override func viewDidLoad() {
		beforeTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 375, height: 50))
		afterTextField = UITextField(frame: CGRect(x: 0, y: 50, width: 375, height: 50))
		view.addSubview(beforeTextField)
		view.addSubview(afterTextField)
		beforeTextField.keyboardType = .numberPad
		afterTextField.keyboardType = .numberPad
		beforeTextField.textAlignment = .center
		afterTextField.textAlignment = .center
		beforeTextField.placeholder = "Введите вес ДО"
		afterTextField.placeholder = "Введите вес ПОСЛЕ"
		beforeTextField.delegate = self
		afterTextField.delegate = self
		beforeTextField.becomeFirstResponder()
				
	}

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		textField.keyboardType = .numberPad
		switch textField {
			case beforeTextField:
				let toolbar = CustomToolbar(leftButtonType: .None, rightButtonType: .Next)
				toolbar.buttonDelegate = self
				textField.inputAccessoryView = toolbar
			case afterTextField:
				let toolbar = CustomToolbar(leftButtonType: .None, rightButtonType: .Done)
				toolbar.buttonDelegate = self
				textField.inputAccessoryView = toolbar
			default:
			fatalError("Unknown textfield in BA VC")
		}
		
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		//MARK: - Use regexp instead!
		
		let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
		if string.rangeOfCharacter(from: invalidCharacters) == nil {
			
			//MARK: - Move this to separate method and use everywhere.
			
			if let text = textField.text, let textRange = Range(range, in: text) {
				let updatedText = text.replacingCharacters(in: textRange, with: string)
				
				switch textField {
					case beforeTextField:
						weightBefore = Int64(updatedText) ?? 0
					case afterTextField:
						weightAfter = Int64(updatedText) ?? 0
					default:
						fatalError("Unknown textfield in Before/After VC")
				}
				
				let totalWeight = weightBefore > weightAfter ? weightBefore - weightAfter : 0
				delegate?.didUpdatedWeight(weight: totalWeight)
			}
			return true }
		else {
			return false
		}
	}
}


extension BeforeAfterVC: CustomToolbarDelegate {
	func donePressed() {
		self.view.removeFromSuperview()
		self.removeFromParent()
		delegate?.didEndEnteringWeight()
	}
	
	func nextPressed() {
		afterTextField.becomeFirstResponder()
	}
	
	func weightPressed() {
		
	}
	
	
}
