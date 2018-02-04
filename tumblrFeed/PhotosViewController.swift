//
//  PhotosViewController.swift
//  tumblrFeed
//
//  Created by Nancy Gomez on 2/3/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We will provide the data for the table view
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        fetchTumblr()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTumblr() {
        
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // this will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // receives data from url and we make it a json object and unwrap it
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let responseD = dataDictionary["response"] as! [String: Any]
                self.posts = responseD["posts"] as! [[String: Any]]
                
                // add info to the table!
                self.tableView.reloadData()
            }
        }
        // Start the task to get the info!
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        // Lots of UNWRAPPING
        let photos = self.posts[indexPath.row]["photos"] as! [[String: Any]]
        
        let photoObj = photos[0]["original_size"] as! [String: Any]
        
        let photoLink = photoObj["url"] as! String
        
        let photoURL = URL(string: photoLink)!
        
        // adding image to the cell
        cell.blogPhoto.af_setImage(withURL: photoURL)

        return cell
    }

}
