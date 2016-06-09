//
//  CuresVCell.swift
//  Development
//
//  Created by fangchanok on 8/30/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit

class CuresVCell: UITableViewCell {
    
    @IBOutlet weak var mySymptom: UILabel!
    @IBOutlet weak var DetailsSym: UITextView!
    @IBOutlet weak var myDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
