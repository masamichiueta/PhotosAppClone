//
//  PagingCollectionViewFlowLayout.swift
//  PhotosAppClone
//
//  Created by Masamichi Ueta on 2017/06/20.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit

class PagingCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var pageWidth: CGFloat {
        return self.collectionView!.bounds.width + self.minimumLineSpacing
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.minimumLineSpacing = 50
        self.scrollDirection = .horizontal
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let currentPage = self.collectionView!.contentOffset.x / pageWidth
        
        if fabs(velocity.x) > 0.1 {
            let nextPage = velocity.x > 0.0 ? ceil(currentPage) : floor(currentPage)
            return CGPoint(x: nextPage * self.pageWidth, y: proposedContentOffset.y)
        }
        
        return CGPoint(x: round(currentPage) * self.pageWidth, y: proposedContentOffset.y)
    }
}
