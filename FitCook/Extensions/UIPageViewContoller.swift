import UIKit

extension UIPageViewController {
	open override func viewDidLayoutSubviews() {
		for subview in view.subviews {
			if subview is UIScrollView {
				subview.frame = view.bounds
			}
			if let control = subview as? UIPageControl {
				view.bringSubviewToFront(control)
				control.pageIndicatorTintColor = #colorLiteral(red: 0.3725490196, green: 0.4235294118, blue: 0.6862745098, alpha: 1)
			}
		}
	}
}
