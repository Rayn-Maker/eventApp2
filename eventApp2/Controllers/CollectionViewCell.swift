//
//  CollectionViewCell.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/8/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import Firebase

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImag: UIImageView!
    @IBOutlet weak var myPostImag: UIImageView!
    
    var postAutPicData: Data!
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    var post2: Post! {
        didSet {
            self.updateUI2()
        }
    }
    
    func updateUI() {
        if let imageDownloadURL = post.picUrl {
            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("******** \(error)")
                } else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.postImag.image = image
                        }
                    }
                }
                
            }
        }
    }
    
    func updateUI2() {
        if let imageDownloadURL = post2.picUrl {
            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("******** \(error)")
                } else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.myPostImag.image = image
                        }
                    }
                }
                
            }
        }
    }
}
