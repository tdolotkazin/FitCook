import UIKit

protocol WeightChildView {
	func calculateWeight() -> Int64
}

class RecipeItemViewController: UIViewController {
	var selectedRecipeItem: RecipeItem?
	var coreData: CoreDataHelper?
	var weight: Int64?
	var delegate: WeightChildView?
	
	@IBOutlet weak var containerView: UIView!
	
	@IBOutlet weak var caloriesTextField: UITextField!
	
	private lazy var pureWeightViewController: UIViewController = {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		var VC = storyboard.instantiateViewController(identifier: "PureWeightVC") as! PureWeightVC
		return VC
	}()
	
	private lazy var tareViewController: UIViewController = {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		var VC = storyboard.instantiateViewController(identifier: "TareVC") as! TareVC
		VC.coreData = self.coreData
		return VC
	}()
	
	private lazy var beforeAfterViewController: UIViewController = {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		var VC = storyboard.instantiateViewController(identifier: "BeforeAfterVC") as! BeforeAfterVC
		return VC
	}()
	
	private func add(_ child: UIViewController) {
		addChild(child)
		containerView.addSubview(child.view)
		child.view.frame = containerView.bounds
		child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		child.didMove(toParent: self)
		delegate = child as? WeightChildView
	}
	
	private func remove(_ child: UIViewController) {
		child.willMove(toParent: nil)
		child.view.removeFromSuperview()
		child.removeFromParent()
	}
	
	private func updateView(index: Int) {
		switch index {
			case 0:
				add(pureWeightViewController)
				remove(tareViewController)
				remove(beforeAfterViewController)
			case 1:
				add(tareViewController)
				remove(pureWeightViewController)
				remove(beforeAfterViewController)
			case 2:
				add(beforeAfterViewController)
				remove(pureWeightViewController)
				remove(tareViewController)
			default:
				print("Error with segmented control")
		}
	}
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = selectedRecipeItem?.ingredient!.name
		add(pureWeightViewController)
		
		if let kcal = selectedRecipeItem?.ingredient?.kcal, kcal != 0 {
			caloriesTextField.text = "\(kcal)"
		}
	}
		
	@IBAction func saveButtonPressed(_ sender: UIButton) {
		selectedRecipeItem?.weight = delegate?.calculateWeight() ?? 0
		selectedRecipeItem?.ingredient?.kcal = Int64(caloriesTextField.text!) ?? 0
		coreData?.save()
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		updateView(index: sender.selectedSegmentIndex)
	}
	
	
}
