//
//  ZoomableCollectionViewCell.swift
//  PhotosAppClone
//
//  Created by Masamichi Ueta on 2017/06/20.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit

protocol ZoomableCollectionViewCellDelegate: class {
    func imageDidZoom(scrollView: UIScrollView)
}

class ZoomableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    weak var delegate: ZoomableCollectionViewCellDelegate?
    
    var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scrollView.delegate = self
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleAspectFill
        scrollView.addSubview(imageView)
        
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateImageFrame()
    }
    
    func updateImageFrame() {
        if let size = imageView.image?.size {
            self.layoutIfNeeded()
            // imageViewのサイズがscrollView内に収まるように調整
            let wrate = scrollView.frame.width / size.width
            let hrate = scrollView.frame.height / size.height
            let rate = min(wrate, hrate)
            imageView.frame.size = CGSize(width: size.width * rate, height: size.height * rate)
            
            // contentSizeを画像サイズに設定
            scrollView.contentSize = imageView.frame.size
            // 初期表示のためcontentInsetを更新
            updateScrollInset()
        }
    }
    
    fileprivate func updateScrollInset() {
        // imageViewの大きさからcontentInsetを再計算
        // なお、0を下回らないようにする
        scrollView.contentInset = UIEdgeInsets(
            top: max((scrollView.frame.height - imageView.frame.height)/2, 0),
            left: max((scrollView.frame.width - imageView.frame.width)/2, 0),
            bottom: 0,
            right: 0)
    }
    
    
    func reset() {
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale
    }
}

extension ZoomableCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollInset()
        self.delegate?.imageDidZoom(scrollView: scrollView)
    }
}
