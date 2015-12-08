//
//  TextGameEngine.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/26/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import CoreFoundation
import CoreData

class TextGameEngine {
    //index of the letter in the word to type
    private var currentLetterIndex = 0
    //index of the word to retrieve in the text game model
    private var currentWordIndex = 0
    private var textGameModel = TextGameModel()
    private var errors = 0
    private var numberOfCorrectLetters = 0
    private var numberOfCorrectWords = 0
    private var correctWords = [String]()
    private let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var gameStatus = GameState.CouldBegin
    var wordToType : String {
        if currentWordIndex < self.textGameModel.gameModelWords.count {
            let word = self.textGameModel.gameModelWords[currentWordIndex]
            return word
        }
        return ""
    }
    
    func reset() {
        saveGameContext(correctWords, numOfCorrectLetters: numberOfCorrectLetters, numOfCorrectWords: numberOfCorrectWords)
        textGameModel.shuffleGameModelArray() //always call this first
        //reset all attributes
        currentLetterIndex = 0
        currentWordIndex = 0
        errors = 0
        numberOfCorrectWords = 0
        numberOfCorrectLetters = 0
        correctWords.removeAll()
        //reinstate new word
        attributeWordToType = NSMutableAttributedString(string: self.wordToType)
    }
    
    lazy var attributeWordToType: NSMutableAttributedString = {
        let word = self.colorString(NSMutableAttributedString(string: self.wordToType), atIndex:0, color: UIColor.purpleColor())
        return word
    }()
    
    func compareStringWithWordToTypeAtCurrentLetterIndex(string: String) {
        if currentLetterIndex < wordToType.characters.count - 1 {
            let index = wordToType.startIndex.advancedBy(currentLetterIndex)
            if string == String(wordToType[index]).lowercaseString {
                colorString(attributeWordToType, atIndex: currentLetterIndex, color: UIColor.greenColor())
                colorString(attributeWordToType, atIndex: currentLetterIndex + 1, color: UIColor.purpleColor())
                currentLetterIndex++ //point to next letter in the word
                numberOfCorrectLetters++ //append correct letter count
            } else {
                //error
                errors++ //append error count
                playGameSound(.Hit)
                colorString(attributeWordToType, atIndex: currentLetterIndex, color: UIColor.redColor())
            }
        }else if currentLetterIndex == wordToType.characters.count - 1 {
            //on last letter of the word
            let index = wordToType.startIndex.advancedBy(currentLetterIndex)
            if string == String(wordToType[index]) {
                correctWords.append(wordToType) //append the correct word to the dictionary
                currentWordIndex++ //append word index to point to next word in the TextGameModel array
                numberOfCorrectLetters++ //append correct letter count
                numberOfCorrectWords++ //append correct word count
                currentLetterIndex = 0 //reset letter index to point to first letter
                attributeWordToType = NSMutableAttributedString(string: self.wordToType)
                playGameSound(.Wing)
                colorString(attributeWordToType, atIndex: 0, color: UIColor.purpleColor())
            } else {
                //error
                playGameSound(.Hit)
                errors++ //append error count
                colorString(attributeWordToType, atIndex: currentLetterIndex, color: UIColor.redColor())
            }
        }
    }
    
    private func colorString(attributedString: NSMutableAttributedString, atIndex: Int, color: UIColor) -> NSMutableAttributedString {
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(atIndex, 1))
        return attributedString
    }
    
    //MARK: Game Sounds
    func playGameSound(soundEffect: SoundEffects) {
        let soundEffectTitle: String
        switch soundEffect {
        case .Die:
            soundEffectTitle = "sfx_die"
        case .Hit:
            soundEffectTitle = "sfx_hit"
        case .Wing:
            soundEffectTitle = "sfx_wing"
        case .Point:
            soundEffectTitle = "sfx_point"
        }
        guard let soundPath = NSBundle.mainBundle().pathForResource(soundEffectTitle, ofType: "mp3") else {
            return
        }
        var soundId : SystemSoundID = SystemSoundID()
        let soundURL = NSURL(fileURLWithPath: soundPath)
        
        AudioServicesCreateSystemSoundID((soundURL as CFURLRef), &soundId)
        AudioServicesPlaySystemSound(soundId)
    }
    
    enum SoundEffects {
        case Point
        case Wing
        case Die
        case Hit
    }

    enum GameState {
        case CouldBegin
        case Began
        case Paused
        case Ended
    }
    
    //MARK: Core Data Manager
    func saveGameContext(correctWords: [String], numOfCorrectLetters: Int, numOfCorrectWords: Int) {
        let qualityOfService = DISPATCH_QUEUE_PRIORITY_HIGH
        let queue = dispatch_get_global_queue(qualityOfService, 0)
        //save game stats
        dispatch_async(queue) {
            let newGame = NSEntityDescription.insertNewObjectForEntityForName("Game", inManagedObjectContext: self.appDelegate.managedObjectContext) as! Game

            newGame.id = NSDate()
            
            let array = NSArray(array: correctWords)
            newGame.words = NSKeyedArchiver.archivedDataWithRootObject(array)
            
            let newStatistic = NSEntityDescription.insertNewObjectForEntityForName("Statistic", inManagedObjectContext: self.appDelegate.managedObjectContext) as! Statistic
            newStatistic.game = newGame
            newStatistic.wordsTyped = numOfCorrectWords
            newStatistic.lettersTyped = numOfCorrectLetters
            
            newGame.score = newStatistic
            //save core data
            do {
                try self.appDelegate.managedObjectContext.save()
            } catch {
                print("fata error saving core data \(error)")
            }
        }
    
        //save overall stats
        dispatch_async(queue) {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let overallCorrectWords = userDefaults.integerForKey(UserdefaultsKey.LifeTimeTypedWords.rawValue) + numOfCorrectWords
            userDefaults.setInteger(overallCorrectWords, forKey: UserdefaultsKey.LifeTimeTypedWords.rawValue)

            let overallCorrectLetter = userDefaults.integerForKey(UserdefaultsKey.LifeTimeTypedLetters.rawValue) + numOfCorrectLetters
            userDefaults.setInteger(overallCorrectLetter, forKey: UserdefaultsKey.LifeTimeTypedLetters.rawValue)
            
            let highestWordCount = userDefaults.integerForKey(UserdefaultsKey.MostTypedWords.rawValue)
            if highestWordCount < numOfCorrectWords {
                userDefaults.setInteger(numOfCorrectWords, forKey: UserdefaultsKey.MostTypedWords.rawValue)
            }
            
            let highestLetterCount = userDefaults.integerForKey(UserdefaultsKey.MostTypedWords.rawValue)
            if highestLetterCount < numOfCorrectLetters {
                userDefaults.setInteger(numOfCorrectLetters, forKey: UserdefaultsKey.MostTypedLetters.rawValue)
            }
            
            userDefaults.synchronize()
        }
    }
}