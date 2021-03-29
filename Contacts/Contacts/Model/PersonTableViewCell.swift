//
//  PersonTableViewCell.swift
//  Contacts
//
//  Created by tk on 20.03.21.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var photoIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
