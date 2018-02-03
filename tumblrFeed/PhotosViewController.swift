//
//  PhotosViewController.swift
//  tumblrFeed
//
//  Created by Nancy Gomez on 2/3/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit
import Alamofire

class PhotosViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    

    var posts: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        fetchTumblr()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchTumblr() {
        // Start dat circle YEET
        //activityIndicator.startAnimating()
        
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // this will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // receives data from url and we make it a json object
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let responseD = dataDictionary["response"] as! [String: Any]
                self.posts = responseD["posts"] as! [[String: Any]]
                let photos = self.posts[0]["photos"] as! [[String: Any]]
                let photoObj = photos[0]["original_size"] as! [String: Any]
                let photoURL = photoObj["url"] as! String
                
                
                print(photoURL)
                
                // Now we extract the movies from the json object
                //self.movies = dataDictionary["results"] as! [[String: Any]]
                // table view is set up faster than request gets returned, so let's reload!
                //self.tableView.reloadData()
                //self.refreshControl.endRefreshing()
            }
        }
        // Start the task to get the info!
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath)
        
        return cell
    }

}
