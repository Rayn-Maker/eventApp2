//
//  PostsVC.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/7/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PostsVC: UIViewController {

    
    @IBOutlet weak var postsTable: UITableView!
    
    var postArr = [Post]()
    let ref = Database.database().reference()
    var handle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        self.postsTable.rowHeight = 360.0
        fetchStudent()
    }
    
    func fetchStudent() {
        Database.database().reference().child("Posts").observe(.childAdded) { (snapshot) in
            let newPost = Post(snapShot: snapshot)
            DispatchQueue.main.async {
                self.postArr.insert(newPost, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.postsTable.insertRows(at: [indexPath], with: .top)
            }
        }
//        handle = ref.child("Posts").queryOrderedByKey().observe( .value, with: { response in
//            if response.value is NSNull {
//                /// dont do anything
//            } else {
// 
//            }
//        })
    }

}


extension PostsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as! TableViewCell
        let post = self.postArr[indexPath.row]
        cell.post = post
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // segueToClassRoom
//        performSegue(withIdentifier: "segueToClassRoom", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToClassRoom"{
//            let vc = segue.destination as? MyClassRoomVC
//            let indexPath = myClassesTableView.indexPathForSelectedRow
//            vc?.fetchObject = myClassesArr[(indexPath?.row)!]
        }
    }
}
