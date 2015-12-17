//
//  Game.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/27/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation
import CoreData


class Game: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    //MARK: - Initialize
    convenience init(id: NSDate, words: NSObject, score: Statistic, needSave: Bool,  context: NSManagedObjectContext?) {
        
        // Create the NSEntityDescription
        let entity = NSEntityDescription.entityForName("Game", inManagedObjectContext: context!)
        
        
        if(!needSave) {
            self.init(entity: entity!, insertIntoManagedObjectContext: nil)
        } else {
            self.init(entity: entity!, insertIntoManagedObjectContext: context)
        }
        
        // Init class variables
        self.id = id
        self.score = score
        self.words = NSKeyedArchiver.archivedDataWithRootObject(words)
    }
}
