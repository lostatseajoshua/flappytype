//
//  GameStatsViewController.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/26/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation
import UIKit

class GameStatsViewController: UIViewController, UITableViewDataSource {
    
    var numberOfCorrectWords = 0
    var numberOfCorrectLetters = 0
    var errors = 0
    var correctWords = [String]()
    
    @IBOutlet weak var correctWordsLabel: UILabel!
    @IBOutlet weak var correctLettersLabel: UILabel!
    @IBOutlet weak var errorsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        correctWordsLabel.text = "Correct Words: " + "\(numberOfCorrectWords)"
        correctLettersLabel.text = "Correct Letters: " + "\(numberOfCorrectLetters)"
        errorsLabel.text = "Errors: " + "\(errors)"
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareScore(sender: UIBarButtonItem) {
        let activityView = UIActivityViewController(activityItems: ["Look at my score on Flappy Type! \(numberOfCorrectWords)"], applicationActivities: nil)
        activityView.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop]
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            let popup: UIPopoverController = UIPopoverController(contentViewController: activityView)
            popup.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Any, animated: true)
        } else {
            self.presentViewController(activityView, animated: true, completion: nil)

        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Words Typed"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = correctWords[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return correctWords.count
    }
}
