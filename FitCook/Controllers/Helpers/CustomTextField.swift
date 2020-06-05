import UIKit

class CustomTextField: UITextField {
	var coreData: CoreDataHelper?
	var resultsList = [Ingredient]()
	var tableView : UITableView?
	
	override func willMove(toWindow newWindow: UIWindow?) {
		super.willMove(toWindow: newWindow)
		tableView?.removeFromSuperview()
	}
	
	func configureTableView() {
		if let tableView = tableView {
			tableView.delegate = self
			tableView.dataSource = self
			tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
			//converting tableView origin to window-based coordinates
			tableView.frame.origin = self.convert(tableView.frame.origin, to: nil)
			tableView.frame.origin.y += self.frame.height
			tableView.isHidden = true
			tableView.frame.size.width = self.frame.width
			tableView.rowHeight = 44
			self.window?.addSubview(tableView)
		}
	}
	
	func fetchSearchResult(_ string: String) -> [Ingredient] {
		if let results: [Ingredient] = coreData?.loadSearchResults(string: string)
		{
			return results
		} else {
			fatalError("Can not fetch data!")
		}
	}
	
	func showSuggestions(name string: String) {
		resultsList = fetchSearchResult(string)
		if let tableView = tableView {
			tableView.reloadData()
			tableView.frame.size.height = tableView.contentSize.height
			tableView.isHidden = false
		} else {
			tableView = UITableView()
			configureTableView()
			showSuggestions(name: string)
		}
	}
}

//MARK: - TableView Methods

extension CustomTextField: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return resultsList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
		cell.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.968627451, blue: 0.9803921569, alpha: 1)
		let kcalPerWeight = NSLocalizedString("kcal/100gr", comment: "Unit of measurement of calories per weight")
		cell.textLabel?.text = "\(resultsList[indexPath.row].name!) - \(resultsList[indexPath.row].kcal)" + kcalPerWeight
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.text = resultsList[indexPath.row].name
		self.endEditing(false)
		tableView.isHidden = true
	}
}
