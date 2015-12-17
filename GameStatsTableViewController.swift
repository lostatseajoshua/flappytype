//
//  GameStatsTableViewController.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 12/12/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GameStatsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIAlertViewDelegate {

    lazy var gamesFetchResultsController : NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Game")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try gamesFetchResultsController.performFetch()
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetData(sender: UIBarButtonItem) {
        sender.enabled = false
        let alert = UIAlertView(title: "Reset Data", message: "Are you sure you want to reset all game data?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Reset")
        alert.show()
    }
    
    func resetData() {
        //save game stats
        dispatch_async(dispatch_get_main_queue()) {
            if let appDomain = NSBundle.mainBundle().bundleIdentifier {
                NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
            }
            
            if let psc = self.appDelegate.managedObjectContext.persistentStoreCoordinator {
                
                if let store = psc.persistentStores.last {
                    
                    let storeUrl = psc.URLForPersistentStore(store)
                    
                    self.appDelegate.managedObjectContext.lock()
                    
                    
                    self.appDelegate.managedObjectContext.performBlockAndWait() {
                        
                        self.appDelegate.managedObjectContext.reset()
                        
                        do {
                            try psc.removePersistentStore(store)
                            if let path = storeUrl.path {
                                try NSFileManager.defaultManager().removeItemAtPath(path)
                            }
                            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: nil)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            
            self.navigationItem.rightBarButtonItem?.enabled = true
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gameDetail", let indexPath = sender as? NSIndexPath {
            if let game = gamesFetchResultsController.fetchedObjects?[indexPath.row] as? Game {
                if let gameStatController = segue.destinationViewController as? GameStatsDetailTableViewController {
                    gameStatController.game = game
                }
            }
        }
    }
    
    //MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Overall Stats"
        }
        if section == 1 {
            return "Games"
        }
        return ""
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("overallStatsCell", forIndexPath: indexPath) as UITableViewCell
            if indexPath.row == 0 {
                let score = NSUserDefaults.standardUserDefaults().integerForKey(UserdefaultsKey.MostTypedWords.rawValue)
                cell.textLabel?.text = "Most Words Typed:"
                cell.detailTextLabel?.text = "\(score)"
            }
            if indexPath.row == 1 {
                let score = NSUserDefaults.standardUserDefaults().integerForKey(UserdefaultsKey.MostTypedLetters.rawValue)
                cell.textLabel?.text = "Most Letters Typed:"
                cell.detailTextLabel?.text = "\(score)"
            }
            if indexPath.row == 2 {
                let score = NSUserDefaults.standardUserDefaults().integerForKey(UserdefaultsKey.LifeTimeTypedWords.rawValue)
                cell.textLabel?.text = "Lifetime Words Typed:"
                cell.detailTextLabel?.text = "\(score)"
            }
            if indexPath.row == 3 {
                let score = NSUserDefaults.standardUserDefaults().integerForKey(UserdefaultsKey.LifeTimeTypedLetters.rawValue)
                cell.textLabel?.text = "Lifetime Letters Typed:"
                cell.detailTextLabel?.text = "\(score)"
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("gameListCell", forIndexPath: indexPath) as UITableViewCell
            if let game = gamesFetchResultsController.fetchedObjects?[indexPath.row] as? Game {
                if let date = game.id {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeStyle = .ShortStyle
                    dateFormatter.dateStyle = .MediumStyle
                    cell.textLabel?.text = dateFormatter.stringFromDate(date)
                } else {
                    cell.textLabel?.text = ""
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        if section == 1 {
            if let objs = gamesFetchResultsController.fetchedObjects {
                return objs.count
            }
        }
        return 0
    }
    
    //MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            performSegueWithIdentifier("gameDetail", sender: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // remove the deleted item from the model
            if let game = gamesFetchResultsController.fetchedObjects?[indexPath.row] as? Game {
                
                let context:NSManagedObjectContext = appDelegate.managedObjectContext
                context.deleteObject(game)
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    // First initialise an array of NSBlockOperations:
    var blockOperations: [NSBlockOperation] = []
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?)
    {        
        switch(type) {
            
        case .Insert:
            if let newIndexPath = newIndexPath {
                let sectionIndexPath = NSIndexPath(forRow: newIndexPath.row, inSection: 1)
                blockOperations.append(
                    NSBlockOperation(block: { [weak self] in
                        if let this = self {
                            this.tableView.insertRowsAtIndexPaths([sectionIndexPath], withRowAnimation: .Fade)
                        }
                    })
                )
            }
            
        case .Delete:
            if let indexPath = indexPath {
                let sectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 1)
                blockOperations.append(
                    NSBlockOperation(block: { [weak self] in
                        if let this = self {
                            this.tableView.deleteRowsAtIndexPaths([sectionIndexPath], withRowAnimation: .Fade)
                        }
                    })
                )
            }
            
        case .Update:
            if let indexPath = indexPath {
                let sectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 1)
                
                
                blockOperations.append(
                    NSBlockOperation(block: { [weak self] in
                        if let this = self {
                            this.tableView.reloadRowsAtIndexPaths([sectionIndexPath], withRowAnimation: .Fade)
                        }
                    })
                )
            }
            
        case .Move:
            if let indexPath = indexPath {
                if let newIndexPath = newIndexPath {
                    let sectionIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 1)
                    let newSectionIndexPath = NSIndexPath(forRow: newIndexPath.row, inSection: 1)
                    
                    blockOperations.append(
                        NSBlockOperation(block: { [weak self] in
                            if let this = self {
                                this.tableView.deleteRowsAtIndexPaths([sectionIndexPath],
                                    withRowAnimation: UITableViewRowAnimation.Fade)
                                this.tableView.insertRowsAtIndexPaths([newSectionIndexPath],
                                    withRowAnimation: UITableViewRowAnimation.Fade)
                            }
                        })
                    )
                }
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType)
    {
        switch(type) {
            
        case .Insert:
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.tableView.insertSections(NSIndexSet(index: sectionIndex),
                            withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                })
            )
        case .Delete:
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.tableView.deleteSections(NSIndexSet(index: sectionIndex),
                            withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                })
            )
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        for operation in blockOperations {
            operation.start()
        }
        tableView.endUpdates()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.resetData()
        }
    }
    
    deinit {
        for operation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepCapacity: false)
    }

}
