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

// If you want to use any of the UI components, uncomment this line
// import ParseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // ****************************************************************************
        // Initialize Parse SDK
        // ****************************************************************************

        let configuration = ParseClientConfiguration
        {
            (ParseMutableClientConfiguration) in
            
            ParseMutableClientConfiguration.applicationId = "c13f8fd784d4d2cb907582b09092cf5fe08220d5"
            ParseMutableClientConfiguration.clientKey = "6d6d6a964fe4c46bb744610da7b730a17be76220"
            ParseMutableClientConfiguration.server = "http://ec2-34-208-147-125.us-west-2.compute.amazonaws.com:80/parse"
            
        }
        Parse.initialize(with: configuration)

        // ****************************************************************************
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************

        PFUser.enableAutomaticUser()

        let defaultACL = PFACL()

        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true
        defaultACL.getPublicWriteAccess = true

        
        
        
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)

        if application.applicationState != UIApplicationState.background
        {
        }

        let types: UIUserNotificationType = [.alert, .badge, .sound]
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "ef7825dc-5d3e-4469-9e9d-8d7511e5cfcb")
        
        
        
        rememberLogin()
        
        return true
    }

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
    }
    
    func rememberLogin()
    {
        let user: String? = UserDefaults.standard.string(forKey: "userInfo")
        
        if user != nil
        {
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let tabbar = board.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
            
            window?.rootViewController = tabbar
        }
    }

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }

    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
    // }
}
