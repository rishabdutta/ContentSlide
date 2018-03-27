//
//  TabCollectionViewCell.swift
//  ContentSlide
//
//  Created by Rishab Dutta on 12/03/18.
//  Copyright © 2018 Rishab Dutta. All rights reserved.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.font = UIFont.boldSystemFont(ofSize: 15)
            }
            else {
                label.font = UIFont.systemFont(ofSize: 15)
            }
        }
    }

}
