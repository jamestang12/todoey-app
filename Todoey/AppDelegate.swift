//
//  AppDelegate.swift
//  Destini
//
//  Created by James Tang on 01/18/2020.
//  Copyright (c) James Tang. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
             _ = try Realm()
        }catch{
            print("Error initialisting new realm, \(error)")
        }
        
        
        
        return true
    }

}
