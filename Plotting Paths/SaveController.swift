//
//  SaveController.swift
//  Maps
//
//  Created by Austin Bailie on 2016-06-07.
//  Copyright © 2016 Austin Bailie. All rights reserved.
//

import UIKit
import CoreData

class SaveController: UIViewController, UITableViewDataSource {
    

    
    @IBOutlet weak var tableView: UITableView!
    
    var routes = [NSManagedObject]() // a variable that can be stored and retrived in a spread sheet like table called "Maps.xcdatamodled" on left side menu
    
    @IBAction func addName(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .Alert) // pop up alert
        
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction) -> Void in // stores in table view when name saved
            
            let textField = alert.textFields!.first
            self.saveName(textField!.text!)
            self.tableView.reloadData()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in }
        
        alert.addTextFieldWithConfigurationHandler {(textField: UITextField) -> Void in }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Saved Routes"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { // puts data into coredata to access names
                                                                                                            // after app has been terminated
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let route = routes[indexPath.row]
        
        cell!.textLabel!.text = route.valueForKey("name") as? String // this is where my current bug lives
        
        
        return cell!
    }

    

        
    
    
    func saveName(name: String) { // completes the hard save into coredata and checks for errors
        
        
        let managedContext = DataController().managedObjectContext
        
        
        let entity =  NSEntityDescription.entityForName("Route", inManagedObjectContext:managedContext)
        
        let route = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        
        route.setValue(name, forKey: "name")
        
       
        do {
            try managedContext.save()
           
            routes.append(route)
        }
        catch let error as NSError  {
            
            print("Could not save \(error), \(error.userInfo)")
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) { // fetches from coredata when "routes" is called as shown in the earlier code
        super.viewWillAppear(animated)
        
       
        
        let managedContext = DataController().managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Route")
        
        
        do {
            
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            routes = results as! [NSManagedObject]
            
        } catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            
        }
    }
    
    
    
}
