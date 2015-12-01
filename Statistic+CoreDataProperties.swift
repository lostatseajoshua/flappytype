//
//  Statistic+CoreDataProperties.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/30/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Statistic {

    @NSManaged var wordsTyped: NSNumber?
    @NSManaged var lettersTyped: NSNumber?
    @NSManaged var game: Game?

}
