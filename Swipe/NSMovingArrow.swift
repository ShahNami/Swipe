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
        print(red)
        if(red == 1){
            color = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            colorBlendFactor = 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func start(direction: Int, maxX: Float, maxY: Float){
        var moveDir: SKAction
        var resetPosition: SKAction
        
        switch(direction){
        case 0: //Up
            moveDir = SKAction.moveToY(CGFloat(maxY+30) - self.position.y, duration: 3.0)
            resetPosition = SKAction.moveToY(-10, duration: 0)
            break;
        case 1: //Right
            moveDir = SKAction.moveToX(CGFloat(maxX+30) - self.position.x, duration: 1.5)
            resetPosition = SKAction.moveToX(-30, duration: 0)
            break;
        case 2: //Left
            moveDir = SKAction.moveToX(-CGFloat(maxX+30) + self.position.x, duration: 1.5)
            resetPosition = SKAction.moveToX(CGFloat(maxX)+30, duration: 0)
            break;
        case 3: //Down
            moveDir = SKAction.moveToY(-CGFloat(maxY+30) + self.position.y, duration: 3.0)
            resetPosition = SKAction.moveToY(CGFloat(maxY)+10, duration: 0)
            break;
        default: //Right
            moveDir = SKAction.moveToX(CGFloat(maxX+30) - self.position.x, duration: 1.5)
            resetPosition = SKAction.moveToX(-10, duration: 0)
            break;
        }
        
        
        let moveSequence = SKAction.sequence([moveDir, resetPosition])
        runAction(SKAction.repeatActionForever(moveSequence))
    }
    
}
