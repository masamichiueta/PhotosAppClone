//
//  PhotosAppCloneController.swift
//  PhotosAppClone
//
//  Created by Masamichi Ueta on 2017/06/20.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var datas: [MyData]!
    var widthConstraint: CGFloat!
    
    var sorted: [MyData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datas = (0..<10).map { i in
            let image = UIImage(named: "\(i)")!
            return MyData(id: i, image: image, title: "Sample")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
        
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
        
        self.widthConstraint = (self.view.bounds.width - 20) / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    var ascending: Bool = true
    @IBAction func sort(_ sender: Any) {
        
        let sorted = self.datas.sorted(by: { a, b in
            if ascending {
                return a.id > b.id
            } else {
                return b.id > a.id
            }
        })
        
        self.sorted = sorted
        
        collectionView?.performBatchUpdates({ () -> Void in
            for (newIndex, myData) in self.datas.enumerated() {
                let oldIndex = sorted.index(where: { $0.id == myData.id })!
                let fromIndexPath = IndexPath(row: oldIndex, section: 0)
                let toIndexPath = IndexPath(row: newIndex, section: 0)
                self.collectionView?.moveItem(at: fromIndexPath, to: toIndexPath)
            }
        }, completion: { finished in
            self.datas = sorted
            self.sorted = nil
            self.ascending = !self.ascending
            self.collectionView?.reloadData()
        })
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.datas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        let data: MyData
        if let sorted = self.sorted {
            data = sorted[indexPath.row]
        } else {
            data = self.datas[indexPath.row]
        }
        cell.label.text = "\(data.id)"
        cell.image.image = data.image
        cell.widthConstraint.constant = self.widthConstraint
        cell.layoutIfNeeded()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show" {
            let indexPath = sender as! IndexPath
            let vc = segue.destination as! SecondCollectionViewController
            vc.datas = self.datas
            vc.startIndexPath = indexPath
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    

}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let cell = self.collectionView?.cellForItem(at: indexPath) as? MyCollectionViewCell {
            return CGSize(width: self.widthConstraint, height: cell.frame.height)
        }
        return CGSize(width: self.widthConstraint, height: self.widthConstraint)
    }

}
