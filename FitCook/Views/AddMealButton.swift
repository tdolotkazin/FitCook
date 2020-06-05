import UIKit

protocol ButtonDelegate {
	func buttonPressed(sender: Any?)
}

class AddMealButton: UIButton {
	
	var delegate: ButtonDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	convenience init(parent: UIView) {
		self.init(frame: CGRect.zero)
		setImage(UIImage(named: "AddMealButton"), for: .normal)
		parent.addSubview(self)
		frame.size = CGSize(width: 70, height: 70)
		translatesAutoresizingMaskIntoConstraints = false
		centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
		bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor).isActive = true
		addTarget(self, action: #selector(addMealButtonPressed), for: .touchUpInside)
	}
	
	@objc func addMealButtonPressed(_ sender: UIButton!) {
		delegate?.buttonPressed(sender: self)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
