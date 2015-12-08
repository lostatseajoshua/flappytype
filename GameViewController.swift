//
//  GameViewController.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/24/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

class GameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var keyboardTextField: UITextField!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet var beginGameTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    
    let textGameEngine = TextGameEngine()
    var secondsLeft = 15
    var gameTimer = NSTimer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interstitialPresentationPolicy = .Manual
        
        view.addSubview(keyboardTextField)
        
        if sceneView.scene == nil {
            let introScene = InitialViewSKScene(size: sceneView.frame.size, imageName: cloudbackgroundImageName, showBird: false)
            introScene.scaleMode = .Fill            
            sceneView.presentScene(introScene)
        }
        
        scoreButton.hidden = true
        
        // Do any additional setup after loading the view.
        countdownLabel.alpha = 0
        self.pauseButton.titleLabel?.text = "Home"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    @IBAction func beginGame(sender: UITapGestureRecognizer) {
        pauseButton.setTitle("Pause", forState: .Normal)
        startGame()
    }
    
    @IBAction func gameStateAction(sender: UIButton) {
        switch textGameEngine.gameStatus {
        case .Began:
            sender.setTitle("Home", forState: .Normal)
            pauseGame()
        case .CouldBegin, .Ended, .Paused:
            navigationController?.popViewControllerAnimated(true)
            keyboardTextField.resignFirstResponder()
        }
    }
    
    func startGame() {
        
        switch textGameEngine.gameStatus {
        case .Paused:
            resumeGame()
        case .CouldBegin, .Ended:
            keyboardTextField.delegate = self
            scoreButton.hidden = true
            textGameEngine.gameStatus = .Began
            self.keyboardTextField.becomeFirstResponder()
            UIView.animateWithDuration(1, delay: 0, options: .CurveEaseInOut, animations: {
                self.wordLabel.attributedText = self.textGameEngine.attributeWordToType
                self.countdownLabel.text = "01:00"
                self.countdownLabel.alpha = 1.0
                }) {
                    _ in
                    self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerFired", userInfo: nil, repeats: true)
            }
        case .Began:
            break
        }
    }
    
    func pauseGame() {
        gameTimer.invalidate()
        textGameEngine.gameStatus = .Paused
        keyboardTextField.resignFirstResponder()
        wordLabel.text = "Tap here to resume"
    }
    
    func resumeGame() {
        textGameEngine.gameStatus = .Began
        keyboardTextField.becomeFirstResponder()
        self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerFired", userInfo: nil, repeats: true)
        pauseButton.setTitle("Pause", forState: .Normal)
        wordLabel.attributedText = textGameEngine.attributeWordToType
    }
    
    func gameOver() {
        secondsLeft = 60
        textGameEngine.gameStatus = .Ended
        pauseButton.setTitle("Home", forState: .Normal)
        wordLabel.text = "Game Over \n Tap to here to play again."
        keyboardTextField.resignFirstResponder()
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.countdownLabel.alpha = 0
            }, completion: nil)
        self.textGameEngine.reset()
        scoreButton.hidden = false
        self.requestInterstitialAdPresentation()
    }
    
    func timerFired() {
        if secondsLeft > 0 {
            secondsLeft--
            if secondsLeft >= 10 {
                self.countdownLabel.text = "00:\(self.secondsLeft)"
            } else {
                self.countdownLabel.textColor = UIColor.redColor()
                self.countdownLabel.text = "00:0\(self.secondsLeft)"
            }
        } else {
            self.countdownLabel.textColor = UIColor.blackColor()
            keyboardTextField.delegate = nil
            gameTimer.invalidate()
            gameOver()
        }
    }
    
    //MARK: UITextField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == " " || string == "\n" || string == "" {
            return true
        }
        if textGameEngine.gameStatus == .Began {
            textGameEngine.compareStringWithWordToTypeAtCurrentLetterIndex(string.lowercaseString)
            wordLabel.attributedText = textGameEngine.attributeWordToType
            return true
        }
        return false
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textGameEngine.gameStatus == .Began {
            return false
        }
        return true
    }

    // MARK: - NSNotification Keyboard
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            animateWordLabel(up: true, userInfo: userInfo)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            animateWordLabel(up: false, userInfo: userInfo)
        }
    }

    //MARK: Utilites
    private func animateWordLabel(up up: Bool, userInfo: [NSObject:AnyObject]) {
        var animationDuration: NSTimeInterval = 1
        var wordCenterYConstraint: NSLayoutConstraint?
        
        guard let keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else {
            return
        }
        
        for constraint in self.view.constraints {
            if constraint.identifier == wordLabelCenterYConstraintId {
                wordCenterYConstraint = constraint
                break
            }
        }
        
        if let constraint = wordCenterYConstraint {
            
            if let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval {
                animationDuration = duration
            }
            
            let keyboardFrame = self.view.convertRect(keyboardEndFrame, toView: nil)
            
            if up {
                if keyboardFrame.origin.y <= wordLabel.frame.maxY {
                    self.view.layoutIfNeeded()
                    let difference = abs(keyboardFrame.origin.y - self.wordLabel.frame.maxY)
                    UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseIn, animations: {
                        constraint.constant -= difference + 40
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            } else {
                self.view.layoutIfNeeded()
                UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseIn, animations: {
                    constraint.constant = 0
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
}