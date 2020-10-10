//
//  NSMovingArrow.swift
//  Arrow
//
//  Created by Nami Shah on 09/04/16.
//  Copyright © 2016 Nami Shah. All rights reserved.
//

import Foundation
import SpriteKit

class NSMovingArrow: SKSpriteNode {
    
    init(size: CGSize, sprite: SKTexture, rgbw: Int) {
        super.init(texture: sprite, color: UIColor.clear, size: CGSize(width: size.width, height: size.height))
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if(rgbw == 1){
            color = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            colorBlendFactor = 1.0
        } else if(rgbw == 2) {
            color = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
            colorBlendFactor = 1.0
        } else if(rgbw == 3) {
            color = UIColor(red: 42/255, green: 187/255, blue: 155/255, alpha: 1)
            colorBlendFactor = 1.0
        } else if(rgbw == 4) {
            color = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
            colorBlendFactor = 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hasCollided(maxX: CGFloat, maxY: CGFloat ) -> Bool {
        return (self.position.x < -20 || self.position.y < -20 || self.position.x > (maxX+20) || self.position.y > (maxY+20))
    }
    
    func start(direction: Int, maxX: CGFloat, maxY: CGFloat, duration: Double) {
        var moveDir: SKAction
        var resetPosition: SKAction
        
        switch(direction){
        case 0: //Up
            moveDir = SKAction.moveTo(y: (maxY+30) - self.position.y, duration: duration)
            resetPosition = SKAction.moveTo(y: -50, duration: 0)
            break;
        case 1: //Right
            moveDir = SKAction.moveTo(x: (maxX+30) - self.position.x, duration: duration)
            resetPosition = SKAction.moveTo(x: -50, duration: 0)
            break;
        case 2: //Left
            moveDir = SKAction.moveTo(x: -(maxX+30) + self.position.x, duration: duration)
            resetPosition = SKAction.moveTo(x: CGFloat(maxX)+50, duration: 0)
            break;
        case 3: //Down
            moveDir = SKAction.moveTo(y: -(maxY+30) + self.position.y, duration: duration)
            resetPosition = SKAction.moveTo(y: CGFloat(maxY)+50, duration: 0)
            break;
        default: //Right
            moveDir = SKAction.moveTo(x: (maxX+30) - self.position.x, duration: duration)
            resetPosition = SKAction.moveTo(x: -50, duration: 0)
            break;
        }
        
        
        let moveSequence = SKAction.sequence([moveDir, resetPosition])
        run(SKAction.repeatForever(moveSequence))
    }
}
