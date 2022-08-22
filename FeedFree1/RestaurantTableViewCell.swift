//
//  RestaurantTableViewCell.swift
//  FeedFree1
//
//  Created by Rohan Kolappa on 6/21/19.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statusSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImage.layer.cornerRadius = 2
        iconImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
