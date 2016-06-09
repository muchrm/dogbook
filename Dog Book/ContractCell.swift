//
//  ContractCell.swift
//  Dog Book
//
//  Created by MEITOEY on 11/22/2558 BE.
//  Copyright © 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit

class ContractCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
