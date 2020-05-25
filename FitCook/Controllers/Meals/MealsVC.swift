import UIKit
import CoreData

class MealsVC: UIViewController {
	
	private var meals = [Meal]()
	private var coreData: CoreDataHelper!
	private var addMealButton: UIButton?
	private var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		coreData = CoreDataHelper()
		meals = coreData.load()
		createTableView()
		createButton()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden = true
	
	}
	
	override func viewDidAppear(_ animated: Bool) {
		tableView.reloadAndDeselectRow()
	}
			
	//MARK: - Button methods
	
	func createButton() {
		addMealButton = UIButton(type: .custom)
		addMealButton?.setImage(UIImage(named: "AddMealButton"), for: .normal)
		view.addSubview(addMealButton!)
		addMealButton?.frame.size = CGSize(width: 70, height: 70)
		addMealButton?.translatesAutoresizingMaskIntoConstraints = false
		addMealButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		addMealButton?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		addMealButton?.addTarget(self, action: #selector(addMealButtonPressed), for: .touchUpInside)
	}
	
	@objc func addMealButtonPressed(_ sender: UIButton!) {
		let alert = buildAlert(title: "Новое блюдо", message: "Добавьте новое блюдо", OKTitle: "Добавить", cancelTitle: "Отмена") { (mealName) in
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
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		tableView.frame = view.bounds
		tableView?.dataSource = self
		tableView?.delegate = self
		tableView.register(UINib(nibName: "MealCell", bundle: .main), forCellReuseIdentifier: "mealCell")
		navigationController?.navigationBar.backgroundColor = UIColor(named: "Blue")
		tableView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.968627451, blue: 0.9803921569, alpha: 1)
		tableView.separatorStyle = .none
	}
}

extension MealsVC: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meals.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealCell
		cell.mealNameLabel.text = meals[indexPath.row].name
		
		cell.servingCaloriesLabel.text = meals[indexPath.row].calPerServing != 0 ? String(meals[indexPath.row].calPerServing) : ""
		let tempIndex = CGFloat(meals.count - (indexPath.row + 1)) * 0.1
		let cellAlpha = 1 - tempIndex
		let gradientColor = cell.backgroundColor?.withAlphaComponent(cellAlpha)
		cell.backgroundColor = gradientColor
		return cell
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
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
