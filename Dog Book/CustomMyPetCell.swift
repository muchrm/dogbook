//
//  CustomMyPetCell.swift
//  Dog Book
//
//  Created by MEITOEY on 11/17/2558 BE.
//  Copyright © 2558 Pongpanot Chuaysakun. All rights reserved.
//

import UIKit

class CustomMyPetCell: UITableViewCell {

    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petBitthday: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
