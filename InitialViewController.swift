//
//  InitialViewController.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/23/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import UIKit
import iAd

class InitialViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.canDisplayBannerAds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Utilites
    func updateUI() {
        titleLabel.font = UIFont(name: flappyFontName, size: view.frame.height * 0.04)
        playButton.titleLabel?.font = UIFont(name: flappyFontName, size: view.frame.height * 0.05)
        scoreButton.titleLabel?.font = UIFont(name: flappyFontName, size: view.frame.height * 0.05)
    }

}
