//
//  NestedCollectionViewCell.swift
//  PhotosAppClone
//
//  Created by Masamichi Ueta on 2017/06/20.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit

enum State {
    case image, animatingFromImage, canMoveToImage ,animatingFromDetail, detail
}

class NestedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: MyData!
    
    var state: State = .image
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        let nib = UINib(nibName: "ZoomableCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "Zoom")
    }
    
    var firstCellSize: CGSize!
    
    func configure(data: MyData) {
        self.data = data
        self.state = .image
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        self.collectionView.reloadData()
    }
    
    func parallaxImage(diff: CGFloat) {
        if let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ZoomableCollectionViewCell {
            cell.imageView.frame = CGRect(x: diff, y: cell.imageView.frame.minY, width: cell.imageView.frame.width, height: cell.imageView.frame.height)
        }
    }
}

extension NestedCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Zoom", for: indexPath) as! ZoomableCollectionViewCell
            cell.imageView.image = data.image
            self.firstCellSize = self.bounds.size
            cell.updateImageFrame()
            cell.layoutIfNeeded()
            cell.delegate = self
            return cell
        default:
            break
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AACell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            switch self.state {
            case .image:
                self.firstCellSize = self.bounds.size
            default:
                break
            }
            
            return self.firstCellSize
        default:
            break
        }
        
        let size = (self.bounds.width - 20) / 2
        return CGSize(width: size, height: size)
    }
    
}

extension NestedCollectionViewCell: ZoomableCollectionViewCellDelegate {
    func imageDidZoom(scrollView: UIScrollView) {
        if scrollView.zoomScale != scrollView.minimumZoomScale {
            self.collectionView.isScrollEnabled = false
        } else {
            self.collectionView.isScrollEnabled = true
        }
    }
}

extension NestedCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.state == .detail && scrollView.contentOffset.y <= 0 {
            self.state = .canMoveToImage
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch self.state {
        case .image:
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ZoomableCollectionViewCell, scrollView.contentOffset.y > 0 {
                if cell.scrollView.zoomScale == cell.scrollView.minimumZoomScale {
                    self.state = .animatingFromImage
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    UIView.animate(withDuration: 0.25, animations: {
                        self.collectionView.performBatchUpdates({
                            cell.reset()
                            cell.frame = cell.imageView.frame
                            self.firstCellSize = cell.frame.size
                            cell.layoutIfNeeded()
                            
                        }, completion: { finished in
                        })
                    }, completion: { finished in
                        self.state = .canMoveToImage
                        
                    })
                }
            }
        case .animatingFromImage:
           break

        case .animatingFromDetail:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        case .canMoveToImage:
            if scrollView.contentOffset.y > 0 {
                self.state = .detail
            } else {
                if let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ZoomableCollectionViewCell {
                    self.state = .animatingFromDetail
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    UIView.animate(withDuration: 0.25, animations: {
                        self.collectionView.performBatchUpdates({
                            cell.reset()
                            cell.frame = self.bounds
                            self.firstCellSize = self.bounds.size
                            cell.layoutIfNeeded()
                        }, completion: { finished in
                        })
                    }, completion: { finished in
                        self.state = .image
                    })
                }
            }
        default:
            break
        }
    }
}
