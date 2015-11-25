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
    
    let keyboardTextField = UITextField(frame: CGRectMake(0,0,0,0))

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        keyboardTextField.becomeFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
