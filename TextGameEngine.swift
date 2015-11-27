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

class TextGameEngine {
    //index of the letter in the word to type
    var currentLetterIndex = 0
    //index of the word to retrieve in the text game model
    private var currentWordIndex = 0
    private var textGameModel = TextGameModel()
    var errors = 0
    var numberOfCorrectLetters = 0
    var numberOfCorrectWords = 0
    var correctWords = [String]()
    var gameStatus = GameState.CouldBegin
    
    var wordToType : String {
        if currentWordIndex < self.textGameModel.gameModelWords.count {
            let word = self.textGameModel.gameModelWords[currentWordIndex]
            return word
        }
        return ""
    }
    
    func reset() {
        textGameModel.shuffleGameModelArray()
        currentLetterIndex = 0
        currentWordIndex = 0
        errors = 0
        numberOfCorrectWords = 0
        numberOfCorrectLetters = 0
        correctWords.removeAll()
        attributeWordToType = NSMutableAttributedString(string: self.wordToType)
    }
    
    lazy var attributeWordToType: NSMutableAttributedString = {
        let word = self.colorString(NSMutableAttributedString(string: self.wordToType), atIndex:0, color: UIColor.purpleColor())
        return word
    }()
    
    func compareStringWithWordToTypeAtCurrentLetterIndex(string: String) {
        if currentLetterIndex < wordToType.characters.count - 1 {
            let index = wordToType.startIndex.advancedBy(currentLetterIndex)
            if string == String(wordToType[index]) {
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
//    
//    -(void)playPointSound
//    {
//    NSString *effectTitle = @"sfx_point";
//    
//    SystemSoundID soundID;
//    
//    NSString *soundPath = [[NSBundle mainBundle] pathForResource:effectTitle ofType:@"mp3"];
//    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
//    
//    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
//    AudioServicesPlaySystemSound(soundID);
//    }

    enum GameState {
        case CouldBegin
        case Began
        case Paused
        case Ended
    }
}