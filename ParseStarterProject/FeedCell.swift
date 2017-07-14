//
//  FeedCell.swift
//  ParseStarterProject-Swift
//
//  Created by Sachin Raut on 21/03/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class FeedCell: UITableViewCell
{
    
    
    @IBOutlet var postImage: UIImageView!
    
    @IBOutlet var userNameLabel: UILabel!

    
    @IBOutlet var commentLabel: UILabel!
    
    
    @IBOutlet var postUUIDLabel: UILabel!
    
    var playerIDArray = [String]()
    
    
    @IBAction func likeButtonClicked(_ sender: Any)
    {
        let likeObject = PFObject(className: "likes")
        
        likeObject["from"] = PFUser.current()?.username
        
        likeObject["postLiked"] = postUUIDLabel.text
        
        likeObject.saveInBackground
        {
            (success, error) in
            
            if error != nil
            {
                print(error?.localizedDescription ?? "Error")
            }
            else
            {
                print("pic liked successfully")
                
                let query = PFQuery(className: "_User")
                
                query.whereKey("username", equalTo: self.userNameLabel!.text)
                
                query.findObjectsInBackground(block: { (objects, error) in
                    
                    if error != nil
                    {
                        print("111")
                        print(error?.localizedDescription ?? "Could not find")
                    }
                    else
                    {
                        self.playerIDArray.removeAll(keepingCapacity: false)
                        
                        for object in objects!
                        {
                            self.playerIDArray.append(object.object(forKey: "playerID") as! String)
                            
                            OneSignal.postNotification(["contents": ["en":"\(PFUser.current()!.username!) has liked your post"],
                                                        "include_player_ids":["\(self.playerIDArray.last!)"],
                                                        "ios_badgeType":"Increase",
                                                        "ios_badgeCount":"1"])
                        }
                        
                    }
                    
                })
                
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
