//
//  AppDelegate.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 02.08.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

//App ID: ca-app-pub-2120545226663778~2616688276
//Ad unit ID: ca-app-pub-2120545226663778/1305328806

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-2120545226663778~2616688276")
        PurchaseManager.instance.fetchProducts()
        
        self.window!.rootViewController = MainController()
        self.window!.makeKeyAndVisible()
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .appThemeColor

        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .appThemeColor
        UINavigationBar.appearance().backgroundColor = .appThemeColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
        
//        UITabBar.appearance().tintColor = .appThemeColor
//        UINavigationBar.appearance().tintColor = .appThemeColor
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.appThemeColor]
//        if #available(iOS 11.0, *) {
//            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.appThemeColor]
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

