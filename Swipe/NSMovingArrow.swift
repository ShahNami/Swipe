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
    
    init(size: CGSize, sprite: SKTexture, red: Int) {
        super.init(texture: sprite, color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        anchorPoint = CGPointMake(0.5, 0.5)
        if(red == 1){
            color = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
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
            moveDir = SKAction.moveToY((maxY+30) - self.position.y, duration: duration)
            resetPosition = SKAction.moveToY(-50, duration: 0)
            break;
        case 1: //Right
            moveDir = SKAction.moveToX((maxX+30) - self.position.x, duration: duration/1.7)
            resetPosition = SKAction.moveToX(-50, duration: 0)
            break;
        case 2: //Left
            moveDir = SKAction.moveToX(-(maxX+30) + self.position.x, duration: duration/1.7)
            resetPosition = SKAction.moveToX(CGFloat(maxX)+50, duration: 0)
            break;
        case 3: //Down
            moveDir = SKAction.moveToY(-(maxY+30) + self.position.y, duration: duration)
            resetPosition = SKAction.moveToY(CGFloat(maxY)+50, duration: 0)
            break;
        default: //Right
            moveDir = SKAction.moveToX((maxX+30) - self.position.x, duration: duration/1.7)
            resetPosition = SKAction.moveToX(-50, duration: 0)
            break;
        }
        
        
        let moveSequence = SKAction.sequence([moveDir, resetPosition])
        runAction(SKAction.repeatActionForever(moveSequence))
    }
}
