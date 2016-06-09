//
//  MatchingCell.swift
//  Matching
//
//  Created by Pongpanot Chuaysakun on 7/18/2558 BE.
//  Copyright (c) 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit

class MatchingCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var nameAgeLiked: UILabel!
    @IBOutlet weak var likeBT: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
