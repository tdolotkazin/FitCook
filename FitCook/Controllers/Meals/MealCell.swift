//
//  MealCell.swift
//  FitCook
//
//  Created by Timur Dolotkazin on 31.03.2020.
//  Copyright © 2020 Timur Dolotkazin. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {

	@IBOutlet weak var mealNameLabel: UILabel!
	@IBOutlet weak var servingCaloriesLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
