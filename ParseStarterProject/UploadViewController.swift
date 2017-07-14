//
//  UploadViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Sachin Raut on 21/03/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse



class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate
{
    
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var uploadButton: UIButton!
    
    @IBAction func uploadButtonClicked(_ sender: Any)
    {
        uploadButton.isEnabled = false
        
        let object = PFObject(className: "posts")
        
        let data = UIImageJPEGRepresentation(postImage.image!, 0.5)
        
        let pfImage = PFFile(name: "image.jpg", data: data!)
        
        object["postImage"] = pfImage
        
        object["postOwner"] = PFUser.current()!.username!
        
        // assign unique id to each post
        
        let uuid = UUID().uuidString
        
        object["postUUID"] = "\(uuid)\(PFUser.current()!.username!)"
        
        object["postComment"] = textView.text
        
        object.saveInBackground { (success, error) in
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
                print("post successfully uploaded")
                
                
                //post notification & add obeserver in FeedViewController
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "newPicture"), object: nil)
                
                self.textView.text = ""
                
                self.postImage.image = UIImage(named: "background.png")
                
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //create tap gesture
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.selectImage))

        imageTap.numberOfTapsRequired = 1
        
        postImage.isUserInteractionEnabled = true
        
        postImage.addGestureRecognizer(imageTap)
        
        uploadButton.isEnabled = false
        
        
        
        //hide keyboard
        
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.hideKeyboard))
        
        hideKeyboard.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(hideKeyboard)
        

        
    }
    
    func selectImage()
    {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        
        pickerController.sourceType = .photoLibrary
        
        pickerController.allowsEditing = true
        
        present(pickerController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
        
        uploadButton.isEnabled = true
        
    }
    
    
    
}
