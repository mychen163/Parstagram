//
//  FeedViewController.swift
//  Parstagram
//
//  Created by M.y Chen on 11/13/20.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadQueries()
    }
    func loadQueries(){
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }else{
                print("Error: \(String(describing: error))")
            }
        }
    }
    func loadMoreQueries(){
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 40
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }else{
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLable.text = user.username
        cell.captionLable.text = post["caption"] as? String
        
        let imageFile = post["image"] as!PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.photoView.af.setImage(withURL: url)
    
        return cell
    }
    
   func tableView(_ tableView:UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
    if indexPath.row+1 == posts.count{
        loadMoreQueries()
    }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
