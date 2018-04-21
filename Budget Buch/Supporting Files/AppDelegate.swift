//
//  AppDelegate.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 26.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.configure(withApplicationID: APP_AD_ID)
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .appThemeColor
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .appThemeColor
        UINavigationBar.appearance().backgroundColor = .appThemeColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().prefersLargeTitles = false
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if !UserDefaults.standard.isNotFirstLoggedIn() {
            DatabaseController.insertCategory(name: health, as: .expense, colorIndex: 0, iconIndex: 57)
            DatabaseController.insertCategory(name: gifts, as: .expense, colorIndex: 1, iconIndex: 30)
            DatabaseController.insertCategory(name: shopping, as: .expense, colorIndex: 2, iconIndex: 54)
            DatabaseController.insertCategory(name: bars, as: .expense, colorIndex: 3, iconIndex: 76)
            DatabaseController.insertCategory(name: groceries, as: .expense, colorIndex: 4, iconIndex: 82)
            DatabaseController.insertCategory(name: restaurant, as: .expense, colorIndex: 5, iconIndex: 83)
            DatabaseController.insertCategory(name: transport, as: .expense, colorIndex: 6, iconIndex: 5)
            DatabaseController.insertCategory(name: education, as: .expense, colorIndex: 7, iconIndex: 63)
            DatabaseController.insertCategory(name: job, as: .expense, colorIndex: 8, iconIndex: 55)
            DatabaseController.insertCategory(name: houseHold, as: .expense, colorIndex: 9, iconIndex: 0)
            DatabaseController.insertCategory(name: electronics, as: .expense, colorIndex: 10, iconIndex: 18)
            DatabaseController.insertCategory(name: holidays, as: .expense, colorIndex: 11, iconIndex: 43)
            DatabaseController.insertCategory(name: savings, as: .expense, colorIndex: 12, iconIndex: 101)
            DatabaseController.insertCategory(name: taxes, as: .expense, colorIndex: 13, iconIndex: 61)
            DatabaseController.insertCategory(name: insurance, as: .expense, colorIndex: 14, iconIndex: 62)
            DatabaseController.insertCategory(name: other, as: .otherExpense, colorIndex: 15, iconIndex: 114)
            
            DatabaseController.insertCategory(name: salery, as: .income, colorIndex: 0, iconIndex: 98)
            DatabaseController.insertCategory(name: other, as: .otherIncome, colorIndex: 1, iconIndex: 114)
            
            UserDefaults.standard.setIsNotFirstLoggedIn(value: true)
            UserDefaults.standard.setLastUpdate(value: Date())
            UserDefaults.standard.setInterval(value: MONTHLY)
            UserDefaults.standard.setFileFormat(value: "CSV")
        } else {
            DatabaseController.insertMissingRepeatingIncomes(DataService.shared.getRepeatingIncome(), beginAt: UserDefaults.standard.getLastUpdate())
            DatabaseController.insertMissingRepeatingExpenses(DataService.shared.getRepeatingExpense(), beginAt: UserDefaults.standard.getLastUpdate())
            UserDefaults.standard.setLastUpdate(value: Date())
        }
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
        // Saves changes in the application's managed object context before the application terminates.
        DatabaseController.saveContext()
    }
    
}

