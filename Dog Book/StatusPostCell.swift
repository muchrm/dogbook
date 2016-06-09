//
//  StatusPostCell.swift
//  Dog Book
//
//  Created by MEITOEY on 11/21/2558 BE.
//  Copyright © 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit

class StatusPostCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var postText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
