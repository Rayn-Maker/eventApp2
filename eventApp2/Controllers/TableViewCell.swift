//
//  TableViewCell.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/7/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import Firebase

class TableViewCell: UITableViewCell {

    @IBOutlet weak var postAutPic: UIImageView!
    @IBOutlet weak var postImag: UIImageView!
    @IBOutlet weak var postMenuBtn: UIButton!
    @IBOutlet weak var postAdd: UIButton!
    @IBOutlet weak var postText: UILabel!
    
    
    var post: Post! {
        didSet {
            self.postText.numberOfLines = 0
            self.updateUI()
        }
    }
    
    
    func updateUI() {
        self.postText.text = post.caption
        
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
                            self?.editImage(image: self!.postImag)
                        }
                    }
                }
                
            }
        }
        if let imageDownloadURL = post.authorPicUrl {
            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("******** \(error)")
                } else {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.postAutPic.image = image
                            self?.editImage(image: self!.postAutPic)
                        }
                    }
                }
                
            }
        }
    }
    
    func editImage(image:UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
 
}
