import UIKit

extension UITableViewCell {
	func setGradient(row: Int, of rowsCount: Int) {
		let tempIndex = CGFloat(rowsCount - (row + 1)) * 0.1
		let cellAlpha = 1 - tempIndex
		backgroundColor = backgroundColor?.withAlphaComponent(cellAlpha)
	}
}
