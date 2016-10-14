//
//  ImageCell.swift
//  firstProject
//
//  Created by Tri on 10/14/16.
//  Copyright © 2016 efode. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var level1Btn: UIButton!

    @IBOutlet weak var level2Btn: UIButton!
    
    @IBOutlet weak var level3Btn: UIButton!
    
    @IBOutlet weak var level4Btn: UIButton!
    
    @IBOutlet weak var nameLab: UILabel!
    
    
    var imageInfo: Image!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
