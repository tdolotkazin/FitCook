import UIKit

class RecipeItemViewController: UIViewController {
	var selectedRecipeItem: RecipeItem?
	var coreData: CoreDataHelper?
	
	@IBOutlet weak var weightTextField: UITextField!
	@IBOutlet weak var kcalTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = selectedRecipeItem?.ingredient!.name
		if let weight = selectedRecipeItem?.weight, weight != 0 {
			weightTextField.text = "\(weight)"
		}
		if let kcal = selectedRecipeItem?.ingredient?.kcal, kcal != 0 {
			kcalTextField.text = "\(kcal)"
		}
	}
		
	@IBAction func saveButtonPressed(_ sender: UIButton) {
		selectedRecipeItem?.weight = Int64(weightTextField.text ?? "0")!
		selectedRecipeItem?.ingredient?.kcal = Int64(kcalTextField.text ?? "0")!
		coreData?.save()
		self.navigationController?.popViewController(animated: true)
	}
}
