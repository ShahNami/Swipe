//
//  GameScene.swift
//  Arrow
//
//  Created by Nami Shah on 09/04/16.
//  Copyright (c) 2016 Nami Shah. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var spriteNum = 0
    var dirNum = 0
    var colorize = 0
    var currentScore = 0
    var highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
    var scoreLabel:SKLabelNode!
    var highscoreLabel:SKLabelNode!
    let tapToStart = SKLabelNode(fontNamed: "DIN Condensed")
    let instruction1 = SKSpriteNode(imageNamed: "WhiteSwipe.png")
    let instruction2 = SKSpriteNode(imageNamed: "RedSwipe.png")
    var arrowObject: NSMovingArrow!
    var gameOver = false
    
    
    func endGame(){
        if(!gameOver) {
            removeAllChildren()
            gameOver = true
            var c: UIColor
            if(colorize == 1){
                c = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            } else {
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
        if(colorize == 1){
            return swiped == dirNum
        } else {
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
        return (4 - (Double(currentScore)/10))
    }
    
    func newArrow(){
        spriteNum = Int(arc4random_uniform(4))
        dirNum = Int(arc4random_uniform(4))
        colorize = Int(arc4random_uniform(2))
        
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
        
        arrowObject = NSMovingArrow(size: CGSizeMake(sprite.size().width/7, sprite.size().height/7), sprite: sprite, red: colorize)
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
        instruction1.position = CGPointMake((view.center.x / 2), 150)
        instruction1.size.width = 100
        instruction1.size.height = 100
        addChild(instruction1)
        
        instruction2.position = CGPointMake(view.center.x + (view.center.x / 2), 150)
        instruction2.size.width = 100
        instruction2.size.height = 100
        addChild(instruction2)
        
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
        tapToStart.position = CGPointMake(view.center.x, view.center.y + 50)
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
