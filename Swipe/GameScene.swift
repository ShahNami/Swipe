//
//  GameScene.swift
//  Arrow
//
//  Created by Nami Shah on 09/04/16.
//  Copyright (c) 2016 Nami Shah. All rights reserved.
//

/*
    TODO:
    - Add something new to the game
 */

import SpriteKit

class GameScene: SKScene {
    
    var spriteNum = 0
    var dirNum = 0
    var rgbw = 0
    var currentScore = 0
    var highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
    var scoreLabel:SKLabelNode!
    var highscoreLabel:SKLabelNode!
    let tapToStart = SKLabelNode(fontNamed: "DIN Condensed")
    let instruction1 = SKSpriteNode(imageNamed: "WhiteSwipe.png")
    let instruction2 = SKSpriteNode(imageNamed: "RedSwipe.png")
    let instruction3 = SKSpriteNode(imageNamed: "BlueSwipe.png")
    let instruction4 = SKSpriteNode(imageNamed: "GreenSwipe.png")
    var arrowObject: NSMovingArrow!
    var gameOver = false
    
    
    func endGame(){
        if(!gameOver) {
            removeAllChildren()
            gameOver = true
            var c: UIColor
            if(rgbw == 1){ //red
                c = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            } else if(rgbw == 2) { //blue
                c = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
            } else if(rgbw == 3) { //green
                c = UIColor(red: 0/255, green: 133/255, blue: 60/255, alpha: 1)
            } else { //white
                c = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
            }
            let reveal = SKTransition.fadeWithColor(c, duration: 0.5)
            let scene = GameOverScene(size: self.size, cs: currentScore, hs: highscore)
            self.view?.presentScene(scene, transition: reveal)
        }
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        if(checkSolution(0)){
            setScore()
            arrowObject.removeFromParent()
            newArrow()
        } else {
            endGame()
        }
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        if(checkSolution(1)){
            setScore()
            arrowObject.removeFromParent()
            newArrow()
        } else {
            endGame()
        }
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        if(checkSolution(2)){
            setScore()
            arrowObject.removeFromParent()
            newArrow()
        } else {
            endGame()
        }
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        if(checkSolution(3)){
            setScore()
            arrowObject.removeFromParent()
            newArrow()
        } else {
            endGame()
        }
    }
    
    func checkSolution(swiped: Int) -> Bool{
        if(rgbw == 1){ //red
            switch(spriteNum) {
            case 0:
                return swiped == 3
            case 1:
                return swiped == 2
            case 2:
                return swiped == 1
            case 3:
                return swiped == 0
            default:
                return swiped == 2
            }
        } else if (rgbw == 2) { //blue
            return swiped == dirNum
        } else if (rgbw == 3) { //green
            switch(dirNum) {
            case 0:
                return swiped == 3
            case 1:
                return swiped == 2
            case 2:
                return swiped == 1
            case 3:
                return swiped == 0
            default:
                return swiped == 2
            }
        } else { //white
            return swiped == spriteNum
        }
    }
    
    func setScore(){
        currentScore += 1
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let hs = userDefaults.valueForKey("highscore") {
            if(currentScore > hs as! Int){
                highscore = currentScore
                userDefaults.setValue(highscore, forKey: "highscore")
                userDefaults.synchronize()
                
            }
        } else {
            userDefaults.setInteger(currentScore, forKey: "highscore")
        }
        
        scoreLabel.text = "\(currentScore)"
        highscoreLabel.text = "\(highscore)"
    }
    
    
    func calcSpeedForScore() -> Double{
        return (currentScore >= 50) ? 1.50 : (4 - (Double(currentScore)/20))
    }
    
    func newArrow(){
        spriteNum = Int(arc4random_uniform(4))
        dirNum = Int(arc4random_uniform(4))
        if(currentScore > 45) {
            rgbw = Int(arc4random_uniform(4))
        } else if(currentScore > 25) {
            rgbw = Int(arc4random_uniform(3))
        } else {
            rgbw = Int(arc4random_uniform(2))
        }
        
        var sprite = SKTexture()
        switch(spriteNum){
        case 0:
            sprite = SKTexture(imageNamed:"arrow_up.png")
            break;
        case 1:
            sprite = SKTexture(imageNamed:"arrow_right.png")
            break;
        case 2:
            sprite = SKTexture(imageNamed:"arrow_left.png")
            break;
        case 3:
            sprite = SKTexture(imageNamed:"arrow_down.png")
            break;
        default:
            sprite = SKTexture(imageNamed:"arrow_right.png")
            break;
        }
        
        arrowObject = NSMovingArrow(size: CGSizeMake(sprite.size().width/18, sprite.size().height/18), sprite: sprite, rgbw: rgbw)
        var startPoint = CGPointMake(0, 0)
        
        switch(dirNum){
        case 0: //Up
            startPoint = CGPointMake(view!.center.x, 0)
            break;
        case 1: //Right
            startPoint = CGPointMake(0, view!.center.y)
            break;
        case 2: //Left
            startPoint = CGPointMake(self.frame.size.width, view!.center.y)
            break;
        case 3: //Down
            startPoint = CGPointMake(view!.center.x, self.frame.size.height)
            break;
        default: //Right
            startPoint = CGPointMake(0, view!.center.y)
            break;
        }
        
        arrowObject.position = startPoint
        addChild(arrowObject)
        arrowObject.start(dirNum, maxX: self.frame.size.width, maxY: self.frame.size.height, duration: calcSpeedForScore())
    }
    
    
    override func didMoveToView(view: SKView) {
        instruction1.position = CGPointMake(view.center.x + (view.center.x / 2), view.center.y + (view.center.y / 2))
        instruction1.size.width = 75
        instruction1.size.height = 75
        addChild(instruction1)
        
        instruction2.position = CGPointMake((view.center.x / 2), view.center.y + (view.center.y / 2))
        instruction2.size.width = 75
        instruction2.size.height = 75
        addChild(instruction2)
        
        instruction3.position = CGPointMake((view.center.x / 2), view.center.y - (view.center.y / 2))
        instruction3.size.width = 75
        instruction3.size.height = 75
        addChild(instruction3)
        
        instruction4.position = CGPointMake(view.center.x + (view.center.x / 2), view.center.y - (view.center.y / 2))
        instruction4.size.width = 75
        instruction4.size.height = 75
        addChild(instruction4)
        
        
        //let appDomain = NSBundle.mainBundle().bundleIdentifier!
        //NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        backgroundColor = UIColor(red: 44/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1)
        
        scoreLabel = SKLabelNode(fontNamed: "DIN Condensed")
        scoreLabel.text = "\(currentScore)"
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPointMake(view.center.x / 3, self.frame.size.height - 40)
        
        addChild(scoreLabel)
        
        highscoreLabel = SKLabelNode(fontNamed: "DIN Condensed")
        highscoreLabel.text = "\(highscore)"
        highscoreLabel.fontSize = 30
        highscoreLabel.position = CGPointMake(view.center.x + (view.center.x / 3)*2, self.frame.size.height - 40)
        
        addChild(highscoreLabel)

        
        tapToStart.text = "Tap to start"
        tapToStart.fontSize = 40
        tapToStart.position = CGPointMake(view.center.x, view.center.y)
        tapToStart.name = "taptostart"
        addChild(tapToStart)

        
        /* Setup your scene here */
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp(_:)))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown(_:)))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if(tapToStart.inParentHierarchy(self)){
            tapToStart.removeFromParent()
            instruction1.removeFromParent()
            instruction2.removeFromParent()
            instruction3.removeFromParent()
            instruction4.removeFromParent()
            newArrow()
            _ =  NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(GameScene.checkCollision), userInfo: nil, repeats: true)
            
        }
    }
    
    func checkCollision(){
        if(arrowObject.hasCollided(self.frame.size.width, maxY: self.frame.size.height)){
            endGame()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
