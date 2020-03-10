//import UIKit
//import CoreData
//
//class KitchenWareController: UITableViewController {
//	var kitchenWare: [Dish] = []
//	
//    override func viewDidLoad() {
//        super.viewDidLoad()
////		let request: NSFetchRequest<Dish> = Dish.fetchRequest()
////		do {
////			kitchenWare = try context.fetch(request)
////		} catch {
////			print("Error fetching kitchenware")
////		}
////		tableView.register(UINib(nibName: "KitchenWareCell", bundle: .main), forCellReuseIdentifier: "dish")
////	//	tableView.rowHeight = CGFloat(exactly: 62) as CGFloat
//    }
//
//    // MARK: - Table view data source
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return kitchenWare.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "dish", for: indexPath) as! KitchenWareCell
//		cell.nameLabel.text = kitchenWare[indexPath.row].name!
//		return cell
//    }
//	
//	//MARK: - IB Actions
//	
//	
//	
//	@IBAction func addDishPressed(_ sender: UIBarButtonItem) {
//		var textField = UITextField()
//		let alert = UIAlertController(title: "Введите посуду", message: nil, preferredStyle: .alert)
//		let action = UIAlertAction(title: "OK", style: .default) { (action) in
////			let newDish = Dish(context: self.context)
////			newDish.name = textField.text
////			self.kitchenWare.append(newDish)
////			save()
//			self.tableView.reloadData()
//		}
//		
//		alert.addAction(action)
//		alert.addTextField { (field) in
//			textField = field
//			textField.placeholder = "Введите посуду"
//			textField.autocapitalizationType = .sentences
//		}
//		present(alert, animated: true, completion: nil)
//	}
//}
