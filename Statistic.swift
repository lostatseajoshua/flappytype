//
//  Statistic.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/27/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation
import CoreData


class Statistic: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    convenience init(wordsTyped: NSNumber, lettersTyped: NSNumber, needSave: Bool,  context: NSManagedObjectContext?) {
        
        // Create the NSEntityDescription
        let entity = NSEntityDescription.entityForName("Statistic", inManagedObjectContext: context!)
        
        
        if(!needSave) {
            self.init(entity: entity!, insertIntoManagedObjectContext: nil)
        } else {
            self.init(entity: entity!, insertIntoManagedObjectContext: context)
        }
        
        // Init class variables
        self.wordsTyped = wordsTyped
        self.lettersTyped = lettersTyped
    }
}
