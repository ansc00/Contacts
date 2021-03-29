//
//  CustomUILabel.swift
//  Contacts
//
//  Created by tk on 25.03.21.
//

import UIKit

class CustomUILabel: UILabel {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawText(in rect: CGRect) {
        // Drawing code
        //Override insets for padding
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        super.drawText(in: rect.inset(by: insets))
    }
    


}
