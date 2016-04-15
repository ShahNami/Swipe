//
//  GameOverScene.swift
//  Arrow
//
//  Created by Nami Shah on 10/04/16.
//  Copyright © 2016 Nami Shah. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var background = SKSpriteNode(imageNamed: "GameOverBackground.png")
    
    init(size: CGSize, cs: Int, hs: Int) {
        super.init(size: size)
        
        background.zPosition = 0
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = self.frame.size
        addChild(background)
        
        backgroundColor = UIColor(red: 44/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1)

        
        let label = SKLabelNode(fontNamed: "DIN Condensed")
        label.text = "Game over"
        label.fontSize = 50
        label.fontColor = SKColor.whiteColor()
        label.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(label)
        
        let score = SKLabelNode(fontNamed: "DIN Condensed")
        score.text = "\(cs)"
        score.fontSize = 45
        score.fontColor = SKColor.whiteColor()
        score.position = CGPointMake(self.size.width/2, self.size.height/3) //CGPointMake(self.size.width/2, self.size.height - 150)
        self.addChild(score)
        
        let highscore = SKLabelNode(fontNamed: "DIN Condensed")
        highscore.text = "\(hs)"
        highscore.fontSize = 30
        highscore.fontColor = SKColor.whiteColor()
        highscore.position = CGPointMake(self.size.width/2, self.size.height/4)
        self.addChild(highscore)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let reveal : SKTransition = SKTransition.fadeWithColor(UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1), duration: 0.5)
        let scene = GameScene(size: self.view!.bounds.size)
        scene.scaleMode = .AspectFill
        self.view?.presentScene(scene, transition: reveal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}