//
//  Data.swift
//  PhotosAppClone
//
//  Created by Masamichi Ueta on 2017/06/20.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit

class MyData {
    let id: Int
    let image: UIImage
    let title: String
    
    init(id: Int, image: UIImage, title: String) {
        self.id = id
        self.image = image
        self.title = title
    }
}
