//
//  File.swift
//  EventMe
//
//  Created by Radiance Okuzor on 10/20/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class User {
    var firstName: String!
    var lastName: String!
    var fullName: String!
    var email: String!
    var phoneNumber: Int!
    var uid: String!
    var password: String!
    var profilePic: String!
    var profilePicData: Data?
    var profilePicUrl: URL?
}
 
class Post {
    var caption: String!
    var downloadURL: String?
    var authorEmal: String!
    var authorFullName: String!
    var authorPicUrl: String!
    var postId: String!
    var postText: String!
    var timeStamp: String!
    var timeStampDate: Date!
    var timeSince: String!
    var picUrl: String!

    var userStorage: StorageReference!
    private var image: UIImage!
    
    let storage = Storage.storage().reference(forURL: "gs://eventapp2-225e3.appspot.com")
    let ref = Database.database().reference()
    
    init(image: UIImage, caption:String, authorEmail:String, authorFullName:String, authorPicUrl:String) {
        self.image = image
        self.caption = caption
        self.authorPicUrl = authorPicUrl
        self.authorFullName = authorFullName
        self.authorEmal = authorEmail
    }
    
    init(snapShot: DataSnapshot) {
        let y = snapShot.value as! [String:AnyObject]
        if let auEmal = y["authorEmail"] as? String {
            self.authorEmal = auEmal
        }
        if let auEmal = y["authorFullName"] as? String {
            self.authorFullName = auEmal
        }
        if let auEmal = y["authorPicUrl"] as? String {
            self.authorPicUrl = auEmal
        }
        if let auEmal = y["postid"] as? String {
            self.postId = auEmal
        }
        if let auEmal = y["timeStamp"] as? String {
            self.timeStamp = auEmal
        }
        if let auEmal = y["url"] as? String {
            self.picUrl = auEmal
        }
        if let auEmal = y["caption"] as? String {
            self.caption = auEmal
        }

    }
    
    func save() {
        let storage = Storage.storage().reference(forURL: "gs://eventapp2-225e3.appspot.com")
        userStorage = storage.child("Posts")
        let newPostKey = Database.database().reference().child("Posts").childByAutoId().key
        let user = Auth.auth().currentUser
        let timeStamp = String(describing: Date())
        let imageRef = self.userStorage.child("\(newPostKey ?? "").jpg")
         let data = self.image!.jpegData(compressionQuality: 0.5)
        
         let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
            if err != nil {
            } else {
                
            }
            imageRef.downloadURL(completion: { (url, er) in
                if er != nil {
                    print(er!.localizedDescription)
                }
                if let url = url {
                    let params: [String:Any] = ["authorEmail": Auth.auth().currentUser?.email ?? "",
                                                "url":url.absoluteString,
                                                "authorPicUrl":self.authorPicUrl,
                                                "authorFullName":self.authorFullName!,
                                                "timeStamp":timeStamp,
                                                "postId":newPostKey!,
                                                "caption":self.caption]
                    self.ref.child("Users").child(user!.uid).child("MyPosts/\(newPostKey!)").updateChildValues(params)
                    self.ref.child("Posts/\(newPostKey!)").updateChildValues(params)
                }
            })
            
        })
        uploadTask.resume()
    }
}

func getTimeSince(date:Date) -> String {
    var calendar = NSCalendar.autoupdatingCurrent
    calendar.timeZone = NSTimeZone.system
    let components = calendar.dateComponents([ .month, .day, .minute, .hour, .second ], from: date, to: Date())
    //        let months = components.month
    let days = components.day
    let hours = components.hour
    let minutes = components.minute
    let secs = components.second
    var time:Int = days!; var measur:String = "Days ago"
    
    if days == 1 {
        measur = "Day ago"
    } else if days! < 1 {
        measur = "hours ago"
        time = hours!
        if hours == 1 {
            measur = "hour ago"
        } else if hours! < 1 {
            measur = "minutes ago"
            time = minutes!
            if minutes == 1 {
                measur = "minute ago"
            } else if minutes! < 1 {
                measur = "seconds ago"
                time = secs!
            }
        }
    }
    return "\(time)\(measur)"
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}
