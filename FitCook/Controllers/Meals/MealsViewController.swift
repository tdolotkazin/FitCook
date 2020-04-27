import UIKit
import CoreData

class MealsViewController: UITableViewController {
	
	private var meals = [Meal]()
	private var coreData: CoreDataHelper?
	private var addMealButton: UIButton?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		coreData = CoreDataHelper()
		meals = coreData!.load()
		tableView.register(UINib(nibName: "MealCell", bundle: .main), forCellReuseIdentifier: "mealCell")
		navigationController?.navigationBar.backgroundColor = UIColor(named: "Blue")
		self.clearsSelectionOnViewWillAppear = false
		tableView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.968627451, blue: 0.9803921569, alpha: 1)
		createButton()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadAndDeselectRow()
	}
		
	//MARK: - Button methods
	
	func createButton() {
		addMealButton = UIButton(type: .custom)
		addMealButton?.setImage(UIImage(named: "AddMealButton"), for: .normal)
		addMealButton?.adjustsImageWhenHighlighted = false
		navigationController?.view.addSubview(addMealButton!)
		addMealButton?.frame.size = CGSize(width: 70, height: 70)
		addMealButton?.translatesAutoresizingMaskIntoConstraints = false
		addMealButton?.centerXAnchor.constraint(equalTo: (navigationController?.view.centerXAnchor)!).isActive = true
		addMealButton?.bottomAnchor.constraint(equalTo: navigationController!.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		addMealButton?.addTarget(self, action: #selector(addMealButtonPressed), for: .touchUpInside)
	}
	
	@objc func addMealButtonPressed(_ sender: UIButton!) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Add new meal", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "Add", style: .default) { (action) in
			let name = textField.text
			if name != "" {
				let newMeal: Meal = self.coreData!.create(named: name!)
				self.meals.append(newMeal)
				self.tableView.insertRows(at: [IndexPath(row: self.meals.count - 1, section: 0)], with: .automatic)
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(action)
		alert.addAction(cancelAction)
		alert.addTextField { (field) in
			textField = field
			textField.placeholder = "Add new meal"
			textField.autocapitalizationType = .sentences
		}
		present(alert, animated: true, completion: nil)
	}
}

//MARK: - TableView Data Source

extension MealsViewController {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meals.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
		cell.mealNameLabel.text = meals[indexPath.row].name
		
		cell.servingCaloriesLabel.text = meals[indexPath.row].calPerServing != 0 ? String(meals[indexPath.row].calPerServing) : ""
		
		let cellAlpha = 0.1 * CGFloat(1 + indexPath.row)
		let gradientColor = cell.backgroundColor?.withAlphaComponent(cellAlpha)
		cell.backgroundColor = gradientColor
		return cell
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
			self.coreData!.delete(self.meals[indexPath.row])
			self.meals.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
			completionHandler(true)
		}
		let config = UISwipeActionsConfiguration(actions: [delete])
		config.performsFirstActionWithFullSwipe = true
		return config
	}
	
}

//MARK: - TableView Delegate

extension MealsViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toIngredients", sender: self)
	}
}

//MARK: - Navigation

extension MealsViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let nextVC = segue.destination as! RecipeViewController
		if let selectedRow = tableView.indexPathForSelectedRow {
			nextVC.meal = meals[selectedRow.row]
			nextVC.coreData = coreData
		}
	}
}
