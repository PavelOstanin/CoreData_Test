//
//  BreweryListViewController.swift
//  CoreData_Test
//
//  Created by Pavel on 2.04.2018.
//  Copyright © 2018 Pavel. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class BreweryListViewController: UIViewController{

    @IBOutlet weak var breweryTableView: UITableView!
    
    var coreDataStack: CoreDataStack!
    
    var breweries: [Brewery] = []
    var currentBrewery: Brewery!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Brewery> = {
        let fetchRequest: NSFetchRequest<Brewery> = Brewery.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(Brewery.name), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: #keyPath(Brewery.name),
            cacheName: "brewery")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<Brewery>(entityName: "Brewery")
        fetchRequest.fetchLimit = 50;
        do {
            breweries = try coreDataStack.managedContext.fetch(fetchRequest)
            breweryTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if (breweries.count == 0){
            fromServer_Test()
        }
    }
    
    func fromServer_Test(){
        BreweryService.shared().getBreweryList { (success, breweries) in
            for jsonDictionary in breweries {
                let result = jsonDictionary as! Dictionary<String, Any>
                let id = result["id"] as! String?
                let name = result["name"] as! String?
                let descriptions = result["description"] as! String?
                var logoURL = ""
                if let images = result["images"] as! Dictionary<String, Any>?{
                    logoURL = images["squareMedium"] as! String
                }
                //
                let brewery = Brewery(context: self.coreDataStack.managedContext)
                brewery.id = id
                brewery.name = name
                brewery.descriptions = descriptions
                brewery.logoURL = logoURL
                
                self.breweries.append(brewery)
            }
            self.coreDataStack.saveContext()
            self.breweryTableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource
extension BreweryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breweries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreweryTableViewCell", for: indexPath) as! BreweryTableViewCell
        let brewery = breweries[indexPath.row]
        cell.breweryTitleLabel.text = brewery.name
        cell.breweryLogoImageView.sd_setImage(with: URL(string: brewery.logoURL ?? ""), placeholderImage: UIImage.init(named: "no-image-available")) { (image, error, cash, url) in
            
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension BreweryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentBrewery = breweries[indexPath.row]
        performSegue(withIdentifier: segueBeersList, sender: self)
    }
    
}

//MARK: SEGUE
extension BreweryListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueBeersList{
            let beersListVC = segue.destination as! BeersListViewController
            beersListVC.brewery = currentBrewery
            beersListVC.coreDataStack = coreDataStack
        }
    }
    
}

// MARK: NSFetchedResultsControllerDelegate
extension BreweryListViewController: NSFetchedResultsControllerDelegate {
}

