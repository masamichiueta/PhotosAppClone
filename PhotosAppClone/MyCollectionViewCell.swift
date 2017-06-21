//
//  MyCollectionViewCell.swift
//  PhotosAppClone
//
//  Created by Masamichi Ueta on 2017/06/20.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
