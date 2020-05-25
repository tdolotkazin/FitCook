import UIKit

class RecipePageVC: UIViewController {
	
	var recipeItems: [RecipeItem]!
	var selectedItemIndex: Int!
	var coreData: CoreDataHelper?
	
	private var pageController: UIPageViewController?
	private var currentIndex = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
		pageController?.dataSource = self
		pageController?.delegate = self
		pageController?.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
		addChild(pageController!)
		view.addSubview(pageController!.view)
		
		let storyBoard = UIStoryboard(name: "Main", bundle: .main)
		let initialVC = storyBoard.instantiateViewController(identifier: "RecipeItemVC") as! RecipeItemVC
		initialVC.recipeItem = recipeItems[selectedItemIndex]
		initialVC.coreData = coreData
		pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
		
		
		pageController?.didMove(toParent: self)
	}
}

extension RecipePageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let currentVC = viewController as? RecipeItemVC else {
			return nil
		}
		
		var index = recipeItems.firstIndex(of: currentVC.recipeItem)!
		if index == 0 {
			index = recipeItems.count - 1
		} else {
			index -= 1
		}
				
		let storyBoard = UIStoryboard(name: "Main", bundle: .main)
		let beforeVC = storyBoard.instantiateViewController(identifier: "RecipeItemVC") as! RecipeItemVC
		beforeVC.recipeItem = recipeItems[index]
		beforeVC.coreData = coreData
		return beforeVC
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let currentVC = viewController as? RecipeItemVC else {
			return nil
		}
		var index = recipeItems.firstIndex(of: currentVC.recipeItem)!
		if index == recipeItems.count - 1 {
			index = 0
		} else {
			index += 1
		}
				
		let storyBoard = UIStoryboard(name: "Main", bundle: .main)
		let afterVC = storyBoard.instantiateViewController(identifier: "RecipeItemVC") as! RecipeItemVC
		afterVC.recipeItem = recipeItems[index]
		afterVC.coreData = coreData
		return afterVC
	}
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return recipeItems!.count
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return currentIndex
	}
	
}
