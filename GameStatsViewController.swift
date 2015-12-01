//
//  GameStatsViewController.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/26/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GameStatsViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var gamesFetchResultsController : NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Game")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        do {
            try gamesFetchResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetData(sender: UIBarButtonItem) {
        sender.enabled = false
        let alert = UIAlertView(title: "Reset Data", message: "Are you sure you want to reset all game data?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Reset")
        alert.show()
    }
    //    @IBAction func shareScore(sender: UIBarButtonItem) {
    //        let url = "https://itunes.apple.com/us/app/flappy-type/id874653899?mt=8"
    //        let activityView = UIActivityViewController(activityItems: ["Look at my score on Flappy Type! \(numberOfCorrectWords)",url], applicationActivities: nil)
    //        activityView.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop]
    //
    //        if UI_USER_INTERFACE_IDIOM() == .Pad {
    //            let popup: UIPopoverController = UIPopoverController(contentViewController: activityView)
    //            popup.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Any, animated: true)
    //        } else {
    //            self.presentViewController(activityView, animated: true, completion: nil)
    //
    //        }
    //    }
    
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
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Overall Stats"
        }
        if section == 1 {
            return "Games"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("overallStatsCell", forIndexPath: indexPath) as UITableViewCell
            if indexPath.row == 0 {
                let score = NSUserDefaults.standardUserDefaults().integerForKey(UserdefaultsKey.MostTypedLetters.rawValue)
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
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("gameListCell", forIndexPath: indexPath) as UITableViewCell
            if let game = gamesFetchResultsController.fetchedObjects?[indexPath.row] as? Game {
                if let date = game.id {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeStyle = .ShortStyle
                    dateFormatter.dateStyle = .ShortStyle
                    cell.textLabel?.text = dateFormatter.stringFromDate(date)
                } else {
                    cell.textLabel?.text = ""
                }
            }
        }
        
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    // MARK: NSFetchedResultsControllerDelegate
    
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
                tableView.insertRowsAtIndexPaths([newIndexPath],
                    withRowAnimation:UITableViewRowAnimation.Fade)
            }
            
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath],
                    withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
        case .Update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    if let game = gamesFetchResultsController.fetchedObjects?[indexPath.row] as? Game {
                        cell.textLabel?.text = (game.id != nil) ? "\(game.id!)" : ""
                    }
                }
            }
            
        case .Move:
            if let indexPath = indexPath {
                if let newIndexPath = newIndexPath {
                    tableView.deleteRowsAtIndexPaths([indexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
                    tableView.insertRowsAtIndexPaths([newIndexPath],
                        withRowAnimation: UITableViewRowAnimation.Fade)
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
            tableView.insertSections(NSIndexSet(index: sectionIndex),
                withRowAnimation: UITableViewRowAnimation.Fade)
            
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex),
                withRowAnimation: UITableViewRowAnimation.Fade)
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.resetData()
        }
    }
}
