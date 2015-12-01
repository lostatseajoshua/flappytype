//
//  Game+CoreDataProperties.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/29/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Game {

    @NSManaged var id: NSDate?
    @NSManaged var words: NSObject?
    @NSManaged var score: Statistic?

}
