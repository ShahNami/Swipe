//
//  GameViewController.swift
//  Arrow
//
//  Created by Nami Shah on 09/04/16.
//  Copyright (c) 2016 Nami Shah. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {

    var scene: GameScene!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
