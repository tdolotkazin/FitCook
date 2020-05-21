import UIKit

class KitchenWareController: UITableViewController {
	var kitchenWare: [Dish] = []
	var coreData: CoreDataHelper?
		
	override func viewDidLoad() {
		super.viewDidLoad()
		kitchenWare = coreData!.load()
		tableView.register(UINib(nibName: "KitchenWareCell", bundle: .main), forCellReuseIdentifier: "dish")
		tableView.rowHeight = CGFloat(exactly: 60)!
	}
	
	func saveImage(data: Data, for dish: Dish) {
		dish.image = data
		coreData?.save()
	}
	
	// MARK: - Table View Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return kitchenWare.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "dish", for: indexPath) as! KitchenWareCell
		cell.nameLabel.text = kitchenWare[indexPath.row].name!
		cell.weightLabel.text = String(kitchenWare[indexPath.row].weight)
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let presentVC = self.storyboard?.instantiateViewController(identifier: "dishDetailVC") as! KitchenWareDetailVC
		presentVC.dish = kitchenWare[indexPath.row]
		presentVC.coreData = coreData
		presentVC.delegate = self
		present(presentVC, animated: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
			self.coreData?.delete(self.kitchenWare[indexPath.row])
			self.kitchenWare.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			completionHandler(true)
		}
		let config = UISwipeActionsConfiguration(actions: [delete])
		config.performsFirstActionWithFullSwipe = true
		return config
	}
	
//MARK: - IB Actions
	
	@IBAction func addDishPressed(_ sender: UIBarButtonItem) {
		var textField = UITextField()
		let alert = UIAlertController(title: "Введите посуду", message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default) { (action) in
			let newDish:Dish = self.coreData!.create(named: textField.text!)
			self.kitchenWare.append(newDish)
			self.coreData!.save()
			self.tableView.reloadData()
		}
		let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
		alert.addAction(action)
		alert.addAction(cancelAction)
		alert.addTextField { (field) in
			textField = field
			textField.placeholder = "Введите посуду"
			textField.autocapitalizationType = .sentences
		}
		present(alert, animated: true, completion: nil)
	}
}

//MARK: - Delegate to update tableView after dismissing the Detail View

extension KitchenWareController: KitchenWareDetailDelegate {
	func detailViewDismisseed() {
		tableView.reloadAndDeselectRow()
	}
}
