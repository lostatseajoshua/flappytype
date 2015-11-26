//
//  GameViewController.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/24/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var wordLabel: UILabel!
    
    let keyboardTextField = UITextField(frame: CGRectMake(0,0,0,0))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardTextField.
        view.addSubview(keyboardTextField)
        
        if sceneView.scene == nil {
            let introScene = InitialViewSKScene(size: sceneView.frame.size)
            introScene.scaleMode = .Fill
            
            //TODO: Remove after debug
            sceneView.showsFPS = true
            sceneView.showsNodeCount = true
            sceneView.showsDrawCount = true
            
            sceneView.presentScene(introScene)
        }
        
        keyboardTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        keyboardTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: UITextField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
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
