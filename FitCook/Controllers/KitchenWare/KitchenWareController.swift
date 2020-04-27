import UIKit
import CoreData

class KitchenWareController: UITableViewController {
	var kitchenWare: [Dish] = []
	var coreData: CoreDataHelper?
	var selectedCell: KitchenWareCell?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		kitchenWare = coreData!.load()
		tableView.register(UINib(nibName: "KitchenWareCell", bundle: .main), forCellReuseIdentifier: "dish")
		tableView.rowHeight = CGFloat(exactly: 84)!
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
		cell.delegate = self
		cell.nameLabel.text = kitchenWare[indexPath.row].name!
		cell.weightLabel.text = String(kitchenWare[indexPath.row].weight)
		if let imageData = kitchenWare[indexPath.row].image {
			let image = UIImage(data: imageData)
			cell.imageButton.setImage(image, for: .normal)
		} else {
			cell.imageButton.setImage(UIImage(systemName: "camera"), for: .normal)
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let presentVC = self.storyboard?.instantiateViewController(identifier: "dishDetailVC") as! KitchenWareDetailViewController
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
		
		alert.addAction(action)
		alert.addTextField { (field) in
			textField = field
			textField.placeholder = "Введите посуду"
			textField.autocapitalizationType = .sentences
		}
		present(alert, animated: true, completion: nil)
	}
}
//MARK: - Image Picking Methods

/*
Image Picker cropping doesn't work as it should be.
Need to implement my own cropping sometimes.
*/

extension KitchenWareController: KitchenWareCellDelegate {
	func cellButtonPressed(cell: KitchenWareCell) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		picker.sourceType = .camera
		present(picker, animated: true, completion: nil)
		selectedCell = cell
	}
}

extension KitchenWareController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
	{
		guard let pickedImage = info[.editedImage] as? UIImage else { return }
		selectedCell!.imageButton.setImage(pickedImage, for: .normal)
		picker.dismiss(animated: true, completion: nil)
		let dishRow = tableView.indexPath(for: selectedCell!)!.row
		let dish = kitchenWare[dishRow]
		saveImage(data: pickedImage.pngData()!, for: dish)
	}
}

//MARK: - Delegate to update tableView after dismissing the Detail View

extension KitchenWareController: KitchenWareDetailDelegate {
	func detailViewDismisseed() {
		tableView.reloadAndDeselectRow()
	}
}
