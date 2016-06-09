//
//  SymptomViewCell.swift
//  SymptomSearch
//
//  Created by fangchanok on 7/21/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit

class SymptomViewCell: UITableViewCell {
    
    @IBOutlet weak var ImageDog: UIImageView!
    @IBOutlet weak var Details: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [Details .sizeToFit()]
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
