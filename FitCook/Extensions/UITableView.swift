import UIKit

extension UITableView {
	func reloadAndDeselectRow() {
		if let selectedRow = self.indexPathForSelectedRow {
			self.reloadRows(at: [selectedRow], with: .automatic)
			self.deselectRow(at: selectedRow, animated: true)
		}
	}
}
