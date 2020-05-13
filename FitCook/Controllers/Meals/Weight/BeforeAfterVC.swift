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
	var toolbar: UIToolbar!
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
		
		toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
		toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
						 UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))]
		toolbar.translatesAutoresizingMaskIntoConstraints = false
		toolbar.contentMode = .scaleAspectFit
		
	}
	
	@objc func doneButtonPressed() {
		self.view.removeFromSuperview()
		self.removeFromParent()
		delegate?.didEndEnteringWeight()
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		textField.keyboardType = .numberPad
		textField.inputAccessoryView = toolbar
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
