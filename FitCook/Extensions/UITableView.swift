import UIKit

extension UITableView {
	func reloadAndDeselectRow() {
		if let selectedRow = self.indexPathForSelectedRow {
			self.reloadRows(at: [selectedRow], with: .none)
			self.deselectRow(at: selectedRow, animated: false)
		}
	}
}
