//
//  BeersListViewController.swift
//  CoreData_Test
//
//  Created by Pavel on 13.03.18.
//  Copyright © 2018 Pavel. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class BeersListViewController: UIViewController {
    
    @IBOutlet weak var beersTableView: UITableView!
    
    var coreDataStack: CoreDataStack!
    
    var beers: [Beer] = []
    
    var brewery: Brewery!

    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<Beer>(entityName: "Beer")
        fetchRequest.fetchLimit = 50;
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Beer.breweryId), brewery.id!)
        do {
            beers = try coreDataStack.managedContext.fetch(fetchRequest)
            beersTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if (beers.count == 0){
            fromServer_Test()
        }
    }
    
    func fromServer_Test(){
        BreweryService.shared().getBeerList(breweryId: brewery.id!) { (success, beers) in
            for jsonDictionary in beers {
                let result = jsonDictionary as! Dictionary<String, Any>
                let id = result["id"] as! String?
                let name = result["name"] as! String?
                let descriptions = result["description"] as! String?
                var logoURL = ""
                var imageURL = ""
                if let images = result["labels"] as! Dictionary<String, Any>?{
                    logoURL = images["icon"] as! String
                    imageURL = images["medium"] as! String
                }
                //
                let beer = Beer(context: self.coreDataStack.managedContext)
                beer.id = id
                beer.name = name
                beer.descriptions = descriptions
                beer.imageURL = imageURL
                beer.iconURL = logoURL
                beer.breweryId = self.brewery.id
                self.beers.append(beer)
            }
            self.coreDataStack.saveContext()
            self.beersTableView.reloadData()
        }
    }

}

// MARK: UITableViewDataSource
extension BeersListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell", for: indexPath) as! BeerTableViewCell
        let beer = beers[indexPath.row]
        cell.beerNameLabel.text = beer.name
        cell.beerLogoImageView.sd_setImage(with: URL(string: beer.iconURL ?? ""), placeholderImage: UIImage.init(named: "no-image-available")) { (image, error, cash, url) in
            
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension BeersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
