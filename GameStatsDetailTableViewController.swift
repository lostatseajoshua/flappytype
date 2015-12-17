//
//  GameStatsDetailTableViewController.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 12/3/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import UIKit

class GameStatsDetailTableViewController: UITableViewController {
    
    var game: Game!
    
    var words: NSArray {
        if game.words is NSData, let words = NSKeyedUnarchiver.unarchiveObjectWithData(self.game.words as! NSData) as? NSArray {
            return words
        }
        return NSArray()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        }
        if section == 1 {
            return words.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("statCell", forIndexPath: indexPath)
            if let score = game.score {
                if indexPath.row == 0 {
                    cell.textLabel?.text = "Words Typed"
                    cell.detailTextLabel?.text = score.wordsTyped?.stringValue

                }
                if indexPath.row == 1 {
                    cell.textLabel?.text = "Letters Typed"
                    cell.detailTextLabel?.text = score.lettersTyped?.stringValue

                }
            }
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("wordCell", forIndexPath: indexPath)
            if let text = words.objectAtIndex(indexPath.row) as? String {
                 cell.textLabel?.text = text
            }
            return cell
        }

        // Configure the cell...

        return UITableViewCell()
    }

}
