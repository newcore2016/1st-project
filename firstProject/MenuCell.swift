//
//  MenuCell.swift
//  firstProject
//
//  Created by Tri on 10/14/16.
//  Copyright © 2016 efode. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var imageV: UIImageView!

    @IBOutlet weak var descriptionLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
