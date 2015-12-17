//
//  InitialViewController.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/23/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import UIKit
import iAd
import SpriteKit

class InitialViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var soundButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.canDisplayBannerAds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        let title = NSUserDefaults.standardUserDefaults().boolForKey(UserdefaultsKey.SoundSettings.rawValue) ? "Sound On" : "Sound Off"
        soundButton.setTitle(title, forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if sceneView.scene == nil {
            let introScene = InitialViewSKScene(size: sceneView.frame.size, imageName: cloudbackgroundImageName, showBird: true)
            introScene.scaleMode = .AspectFit
            
            sceneView.presentScene(introScene)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        sceneView.presentScene(nil)
    }
    @IBAction func toggleSound(sender: UIButton) {
        let bool = NSUserDefaults.standardUserDefaults().boolForKey(UserdefaultsKey.SoundSettings.rawValue)
        let title = !bool ? "Sound On" : "Sound Off"
        sender.setTitle(title, forState: .Normal)
        NSUserDefaults.standardUserDefaults().setBool(!bool, forKey: UserdefaultsKey.SoundSettings.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: Utilites
    func updateUI() {
        titleLabel.font = UIFont(name: flappyFontName, size: view.frame.height * 0.08)
        playButton.titleLabel?.font = UIFont(name: flappyFontName, size: view.frame.height * 0.045)
        scoreButton.titleLabel?.font = UIFont(name: flappyFontName, size: view.frame.height * 0.045)
    }

}
