//
//  FeedViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Sachin Raut on 21/03/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet var tableView: UITableView!
    
    
    var postOwnerArray = [String]()
    var postCommentArray = [String]()
    var postImageArray = [PFFile]()
    var postUUIDArray = [String]()
    
    var playerID = ""
    
    
    @IBAction func logoutButtonClicked(_ sender: Any)
    {
        PFUser.logOutInBackground
        {
            (error) in
            
            if error != nil
            {
            }
            else
            {
                UserDefaults.standard.removeObject(forKey: "userInfo")
                UserDefaults.standard.synchronize()
                
                let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! SignInViewController
                
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                delegate.window?.rootViewController = signIn
                
            }
            
        }
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        
        cell.userNameLabel.text = postOwnerArray[indexPath.row]
        
        cell.commentLabel.text = postCommentArray[indexPath.row]
        
        cell.postUUIDLabel.text = postUUIDArray[indexPath.row]
        
        postImageArray[indexPath.row].getDataInBackground
        {
            (imageData, error) in
            
            if error != nil
            {
                //print(error?.localizedDescription)
            
            
                let alert = UIAlertController(title: "Alert",
                                              message: error?.localizedDescription,
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK",
                                             style: .cancel,
                                             handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            
            
            }
            else
            {
                //print("12")
                cell.postImage.image = UIImage(data: imageData!)
            }
            
        }
 
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postOwnerArray.count
    }
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        
        self.getPostsFromServer()
        
        
        OneSignal.idsAvailable
        {
            (userID, pushToken) in
            
            if userID != nil
            {
                self.playerID = userID!
                
                let user = PFUser.current()
                
                user?["playerID"] = self.playerID
                
                user?.saveEventually()
                
            }
            
        }
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        //receive local notification from UploadViewController & reload data
        
        NotificationCenter.default.addObserver(self, selector: #selector(FeedViewController.newPicture(_:)), name: NSNotification.Name(rawValue: "newPicture"), object: nil)
        
       
        
    }
    
    
    
    func newPicture(_ notification: Notification)
    {
        getPostsFromServer()
    }
    
    func getPostsFromServer()
    {
        let query = PFQuery(className: "posts")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground
            {
                (objects, error) in
                
                                
                if error != nil
                {
                    //print(error?.localizedDescription)
                    
                    let alert = UIAlertController(title: "Alert",
                                                  message: error?.localizedDescription,
                                                  preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .cancel,
                                                 handler: nil)
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                else
                {
                    
                    self.cleanArrays()
                    
                    for object in objects!
                    {
                        self.postOwnerArray.append(object.object(forKey: "postOwner") as! String)
                        
                        
                        self.postCommentArray.append(object.object(forKey: "postComment") as! String)
                        
                        
                        self.postImageArray.append(object.object(forKey: "postImage") as! PFFile)
                        
                        self.postUUIDArray.append(object.object(forKey: "postUUID") as! String)
                        
                    }
                    
                }
                
                
                self.tableView.reloadData()
        }
    }
    
    
    func cleanArrays()
    {
        self.postImageArray.removeAll(keepingCapacity: false)
        self.postCommentArray.removeAll(keepingCapacity: false)
        self.postOwnerArray.removeAll(keepingCapacity: false)
        self.postUUIDArray.removeAll(keepingCapacity: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
