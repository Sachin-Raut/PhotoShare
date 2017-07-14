/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import OneSignal

class SignInViewController: UIViewController
{

    
    
    @IBOutlet var username: UITextField!
    
    
    @IBOutlet var password: UITextField!
    
    
    @IBAction func signInButtonClicked(_ sender: Any)
    {
        PFUser.logInWithUsername(inBackground: username.text!, password: password.text!)
        { (success, error) in
            if error != nil
            {
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
                print("successfully logged in")
                
                
                UserDefaults.standard.set(self.username.text!, forKey: "userInfo")
                
                UserDefaults.standard.synchronize()
                
                let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                delegate.rememberLogin()
                
                //self.performSegue(withIdentifier: "fromSignInToFeedSegue", sender: nil)
            }
        }
    }
    
    
    
    @IBAction func signUpButtonClicked(_ sender: Any)
    {
        
        if username.text == "" || password.text == ""
        {
            return
        }
        
        
        let user = PFUser()
        
        user.username = username.text
        user.password = password.text
        
        user.signUpInBackground
        {
            (success, error) in
            
            if error != nil
            {
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
                print("User registered successfuly")
                
                UserDefaults.standard.set(self.username.text!, forKey: "userInfo")
                
                UserDefaults.standard.synchronize()
                
                let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                delegate.rememberLogin()
                
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        //7ea2614b-6bb9-4776-b1bf-db4586893dea
    
        //OneSignal.postNotification(["contents":["en": "test notification"],                                   "include_player_ids":["7ea2614b-6bb9-4776-b1bf-db4586893dea"]])
        
        
        
        //hide keyboard
        
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.hideKeyboard))
        
        hideKeyboard.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(hideKeyboard)
    
    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
