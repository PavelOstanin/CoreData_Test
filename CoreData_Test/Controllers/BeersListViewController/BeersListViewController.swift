//
//  BeersListViewController.swift
//  CoreData_Test
//
//  Created by Pavel on 13.03.18.
//  Copyright © 2018 Pavel. All rights reserved.
//

import UIKit

class BeersListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        BreweryService.shared().getBeerList { (success, brewery) in
            
        }
    }

}
