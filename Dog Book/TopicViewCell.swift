//
//  TopicViewCell.swift
//  Topic
//
//  Created by fangchanok on 7/13/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import UIKit

class TopicViewCell: UITableViewCell {

    @IBOutlet weak var TopicName: UILabel!
    @IBOutlet weak var TopicVotes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    ////head shot
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        /////fgfdgdfhf
        // Configure the view for the selected state
    }

}
