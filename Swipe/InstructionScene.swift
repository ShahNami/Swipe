//
//  InstructionScene.swift
//  Swipe
//
//  Created by Nami Shah on 15/04/16.
//  Copyright © 2016 Nami Shah. All rights reserved.
//

import Foundation
import SpriteKit

class InstructionScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = UIColor(red: 44/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1)
    
        var instruction = SKSpriteNode(texture: SKTexture(imageNamed: "WhiteSwipe.png"))
        instruction.position = CGPoint(x: self.size.width/2 - (self.size.width/6)*2, y: self.size.height - (self.size.height/6))
        instruction.size.width = 75
        instruction.size.height = 75
        instruction.zPosition = 100
        addChild(instruction)
        
        instruction = SKSpriteNode(texture: SKTexture(imageNamed: "RedSwipe.png"))
        instruction.position = CGPoint(x: self.size.width - (self.size.width/6), y: (self.size.height / 2) + (self.size.height/6))
        instruction.size.width = 75
        instruction.size.height = 75
        instruction.zPosition = 100
        addChild(instruction)
        
        instruction = SKSpriteNode(texture: SKTexture(imageNamed: "BlueSwipe.png"))
        instruction.position = CGPoint(x: self.size.width/2 - (self.size.width/6)*2, y: self.size.height/2)
        instruction.size.width = 75
        instruction.size.height = 75
        instruction.zPosition = 100
        addChild(instruction)
        
        instruction = SKSpriteNode(texture: SKTexture(imageNamed: "GreenSwipe.png"))
        instruction.position = CGPoint(x: self.size.width - (self.size.width/6), y: (self.size.height / 2) - (self.size.height/6))
        instruction.size.width = 75
        instruction.size.height = 75
        instruction.zPosition = 100
        addChild(instruction)
        
        instruction = SKSpriteNode(texture: SKTexture(imageNamed: "GraySwipe.png"))
        instruction.position = CGPoint(x: self.size.width/2 - (self.size.width/6)*2, y: self.size.height/2 - (self.size.height/6)*2)
        instruction.size.width = 75
        instruction.size.height = 75
        instruction.zPosition = 100
        addChild(instruction)
        
        var label = SKLabelNode(fontNamed: "DIN Condensed")
        label.text = "Swipe the direction the arrow points"
        label.fontSize = 15
        label.fontColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        label.position = CGPoint(x: self.size.width/2 + self.size.width/10, y: self.size.height - (self.size.height/6) - 10)
        self.addChild(label)
        
        label = SKLabelNode(fontNamed: "DIN Condensed")
        label.text = "Swipe the opposite direction the arrow points"
        label.fontSize = 15
        label.fontColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        label.position = CGPoint(x: self.size.width/2 - self.size.width/10, y: (self.size.height / 2) + (self.size.height/6)  - 10)
        self.addChild(label)
        
        label = SKLabelNode(fontNamed: "DIN Condensed")
        label.text = "Swipe the direction the arrow moves"
        label.fontSize = 15
        label.fontColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        label.position = CGPoint(x: self.size.width/2 + self.size.width/10, y: self.size.height/2  - 10)
        self.addChild(label)
        
        label = SKLabelNode(fontNamed: "DIN Condensed")
        label.text = "Swipe the opposite direction the arrow moves"
        label.fontSize = 15
        label.fontColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        label.position = CGPoint(x: self.size.width/2 - self.size.width/10, y: (self.size.height / 2) - (self.size.height/6)  - 10)
        self.addChild(label)
        
        label = SKLabelNode(fontNamed: "DIN Condensed")
        label.text = "Do not swipe when you see this arrow"
        label.fontSize = 15
        label.fontColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        label.position = CGPoint(x: self.size.width/2 + self.size.width/10, y: self.size.height/2 - (self.size.height/6)*2  - 10)
        self.addChild(label)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let reveal : SKTransition = SKTransition.flipVertical(withDuration: 0.5)
        let scene = GameScene(size: self.view!.bounds.size)
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene, transition: reveal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
