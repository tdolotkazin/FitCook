//
//  IngredientsListViewCell.swift
//  FitCook
//
//  Created by Timur Dolotkazin on 21.02.2020.
//  Copyright © 2020 Timur Dolotkazin. All rights reserved.
//

import UIKit

class IngredientsListViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var totalKcalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
