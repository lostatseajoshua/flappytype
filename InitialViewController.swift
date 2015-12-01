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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.canDisplayBannerAds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if sceneView.scene == nil {
            let introScene = InitialViewSKScene(size: sceneView.frame.size, imageName: cloudbackgroundImageName)
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
    
    //MARK: Utilites
    func updateUI() {
        titleLabel.font = UIFont(name: flappyFontName, size: view.frame.height * 0.08)
        playButton.titleLabel?.font = UIFont(name: flappyFontName, size: view.frame.height * 0.045)
        scoreButton.titleLabel?.font = UIFont(name: flappyFontName, size: view.frame.height * 0.045)
    }

}
