import UIKit

func buildAlert(title: String, message: String?, OKTitle: String, cancelTitle: String?, handler: @escaping (String) -> Void) -> UIAlertController {
	var textField = UITextField()
	let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
	let action = UIAlertAction(title: OKTitle, style: .default) { (action) in
		if textField.text != ""  {
			handler(textField.text!)		
		}
	}
	let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
	alert.addAction(action)
	alert.addAction(cancelAction)
	alert.addTextField { (field) in
		textField = field
		textField.autocapitalizationType = .sentences
		textField.placeholder = message
	}
	return alert
}
