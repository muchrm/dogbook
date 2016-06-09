//
//  ProgressCell.swift
//  Dog Book
//
//  Created by fangchanok on 9/4/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell {

    @IBOutlet weak var nameProgress: UILabel!
    @IBOutlet weak var myProgress: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
