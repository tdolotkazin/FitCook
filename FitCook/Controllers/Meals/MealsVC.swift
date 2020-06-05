import UIKit

class MealsVC: UIViewController {
	
	private var meals = [Meal]()
	private var coreData: CoreDataHelper!
	private var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		coreData = CoreDataHelper()
		meals = coreData.load()
		createTableView()
		createButton()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadAndDeselectRow()
	}
}

//MARK: - Button

extension MealsVC: ButtonDelegate {

	func createButton() {
		let addMealButton = AddMealButton(parent: view)
		addMealButton.delegate = self
	}

	func buttonPressed(sender: Any?) {
		let newMealTitle = NSLocalizedString("Add new meal", comment: "Title for adding new meal alert")
		let addTitle = NSLocalizedString("Add", comment: "Add button")
		let cancelTitle = NSLocalizedString("Cancel", comment: "Cancel button")
		let alert = buildAlert(title: newMealTitle, message: nil, OKTitle: addTitle, cancelTitle: cancelTitle) { (mealName) in
			let newMeal: Meal = self.coreData.create(named: mealName)
			self.meals.insert(newMeal, at: 0)
			self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
		}
		present(alert, animated: true, completion: nil)
	}
}

//MARK: - TableView methods

extension MealsVC {
	
	func createTableView() {
		tableView = UITableView()
		view.addSubview(tableView)
		tableView.frame = view.bounds
		tableView.register(UINib(nibName: "MealCell", bundle: .main), forCellReuseIdentifier: "mealCell")
		tableView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.968627451, blue: 0.9803921569, alpha: 1)
		tableView.separatorStyle = .none
		tableView?.dataSource = self
		tableView?.delegate = self
	}
}

extension MealsVC: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meals.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
		cell.configureCell(meal: meals[indexPath.row])
		cell.setGradient(row: indexPath.row, of: meals.count)
		return cell
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteTitle = NSLocalizedString("Delete", comment: "Delete button")
		let delete = UIContextualAction(style: .destructive, title: deleteTitle) { (action, sourceView, completionHandler) in
			self.coreData.delete(self.meals[indexPath.row])
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

extension MealsVC: UITableViewDelegate {	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toIngredients", sender: self)
	}
}

//MARK: - Navigation

extension MealsVC {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let nextVC = segue.destination as! RecipeVC
		if let selectedRow = tableView.indexPathForSelectedRow {
			nextVC.meal = meals[selectedRow.row]
			nextVC.coreData = coreData
		}
	}
}
