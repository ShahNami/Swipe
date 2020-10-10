//
//  CustomCell.swift
//  Swipe
//
//  Created by Nami Shah on 23/04/16.
//  Copyright © 2016 Nami Shah. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var rankLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 8.0
        profileImage.clipsToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
