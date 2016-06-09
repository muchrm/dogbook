//
//  GrowCell.swift
//  Development
//
//  Created by fangchanok on 8/29/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit

class GrowCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
