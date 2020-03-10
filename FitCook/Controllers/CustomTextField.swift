//import UIKit
//
//class CustomTextField: UITextField {
//	var resultsList = [Ingredient]()
//	var tableView: UITableView?
//
//	override func willMove(toWindow newWindow: UIWindow?) {
//		   super.willMove(toWindow: newWindow)
//		   tableView?.removeFromSuperview()
//	   }
//
//	   override open func willMove(toSuperview newSuperview: UIView?) {
//		   super.willMove(toSuperview: newSuperview)
//	   }
//
//	   override open func layoutSubviews() {
//		   super.layoutSubviews()
//		   buildTableView()
//	   }
//	
//	func suggest(_ string:String) {
////		resultsList = loadResults(string: string)
//		tableView?.isHidden = false
//		tableView?.reloadData()
//	}
//	
//
//	func buildTableView() {
//		if let tableView = tableView {
//			tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
//			tableView.delegate = self
//			tableView.dataSource = self
//			self.window?.addSubview(tableView)
//		} else {
//			tableView = UITableView(frame: CGRect.zero)
//		}
//		updateTableView()
//	}
//	
//	func updateTableView() {
//		if let tableView = tableView {
//			superview?.bringSubviewToFront(tableView)
//			var tableHeight: CGFloat = 0
//			tableHeight = tableView.contentSize.height
//			//what the fuck does this line means???
////			if tableHeight < tableView.contentSize.height {
////				tableHeight -= 10
////			}
//
//			var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: tableHeight)
//			tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
//			tableViewFrame.origin.x += 2
//			tableViewFrame.origin.y += frame.size.height + 2
//			UIView.animate(withDuration: 0.2) {
//				self.tableView?.frame = tableViewFrame
//			}
//			tableView.layer.masksToBounds = true
//			tableView.separatorInset = UIEdgeInsets.zero
//			tableView.layer.cornerRadius = 5
//			tableView.separatorColor = UIColor.lightGray
//			tableView.backgroundColor = UIColor.white
//			if self.isFirstResponder {
//				superview?.bringSubviewToFront(self)
//			}
//			tableView.reloadData()
//		}
//	}
//}
//
//extension CustomTextField: UITableViewDelegate, UITableViewDataSource {
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return resultsList.count
//	}
//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell")!
//		cell.backgroundColor = UIColor.clear
//		cell.textLabel?.text = "\(resultsList[indexPath.row].name!) - \(resultsList[indexPath.row].kcal)ккал/100гр"
//		return cell
//	}
//
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print("Row \(indexPath.row) is selected")
//		self.text = resultsList[indexPath.row].name
//		
////		NEED TO SAVE SUGGESTED INGREDIENT!!!
//		
//		tableView.isHidden = true
//		self.endEditing(true)
//	}
//
//}
