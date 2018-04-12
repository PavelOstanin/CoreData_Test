//
//  AppDelegate.swift
//  CoreData_Test
//
//  Created by Pavel on 13.03.18.
//  Copyright © 2018 Pavel. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var  coreDataStack = CoreDataStack(modelName: "CoreData_Test")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard let navController = window?.rootViewController as? UINavigationController,
            let viewController = navController.topViewController as? BreweryListViewController else {
                return true
        }
        
        viewController.coreDataStack = coreDataStack
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

}

