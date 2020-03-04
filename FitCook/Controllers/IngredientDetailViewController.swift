import UIKit
import CoreData

class IngredientDetailViewController: UIViewController {
	var selectedIngredient: Ingredient?
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	@IBOutlet weak var weightTextField: UITextField!
	@IBOutlet weak var kcalTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = selectedIngredient?.name
//		if let weight = selectedIngredient?.weight {
//			weightTextField.text = "\(weight)"
//		}
		if let kcal = selectedIngredient?.kcal {
			kcalTextField.text = "\(kcal)"
		}
	}
		
	@IBAction func saveButtonPressed(_ sender: UIButton) {
	//	selectedIngredient?.weight = Int64(weightTextField.text ?? "0")!
		selectedIngredient?.kcal = Int64(kcalTextField.text ?? "0")!
		saveDetails()
		self.navigationController?.popViewController(animated: true)
	}
	
	func saveDetails() {
		do {
			try context.save()
		} catch {
			print(error)
		}
		
	}
}
