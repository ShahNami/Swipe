//
//  GameScene.swift
//  Arrow
//
//  Created by Nami Shah on 09/04/16.
//  Copyright (c) 2016 Nami Shah. All rights reserved.
//

/*
    TODO:
 */

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var arrowObject: NSMovingArrow!
    var spriteNum = 0
    var dirNum = 0
    var rgbw = 0
    var currentScore = 0
    var highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
    var isFgPlaying = NSUserDefaults.standardUserDefaults().integerForKey("isPlayingFg")
    var gameOver = false
    
    var scoreLabel:SKLabelNode!
    var highscoreLabel:SKLabelNode!
    let tapToStart = SKLabelNode(fontNamed: "DIN Condensed")
    let howToPlay = SKSpriteNode(texture: SKTexture(imageNamed: "InstructionIcon.png"))
    
    let overlayInstructions = SKSpriteNode()
    
    var sound = AVAudioPlayer()
    let bgspeaker = SKSpriteNode(texture: SKTexture(imageNamed: "unmutebg.png"))
    let fgspeaker = SKSpriteNode(texture: SKTexture(imageNamed: "unmute.png"))
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    func playSound(soundName: String)
    {
        if(isFgPlaying == 1 && !gameOver) {
            let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")!)
            do{
                sound = try AVAudioPlayer(contentsOfURL:coinSound)
                sound.volume = 1.0
                if(soundName == "correct"){
                    sound.volume = 0.1
                }
                sound.prepareToPlay()
                sound.play()
            }catch {
                print("Error getting the audio file")
            }
        }
    }

    func endGame(){
        if(!gameOver) {
            //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            playSound("wrong")
            removeAllChildren()
            gameOver = true
            var c: UIColor
            if(rgbw == 1){ //red
                c = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            } else if(rgbw == 2) { //blue
                c = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
            } else if(rgbw == 3) { //green
                c = UIColor(red: 0/255, green: 133/255, blue: 60/255, alpha: 1)
            } else if(rgbw == 4) { //Gray
                c = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
            } else { //white
                c = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
            }
            let reveal = SKTransition.fadeWithColor(c, duration: 0.5)
            let scene = GameOverScene(size: self.size, cs: currentScore, hs: highscore)
            self.view!.presentScene(scene, transition: reveal)
        }
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        if(!tapToStart.inParentHierarchy(self)){
            if(checkSolution(0)){
                setScore()
                arrowObject.removeFromParent()
                newArrow()
            } else {
                endGame()
            }
        }
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        if(!tapToStart.inParentHierarchy(self)){
            if(checkSolution(1)){
                setScore()
                arrowObject.removeFromParent()
                newArrow()
            } else {
                endGame()
            }
        }
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        if(!tapToStart.inParentHierarchy(self)){
            if(checkSolution(2)){
                setScore()
                arrowObject.removeFromParent()
                newArrow()
            } else {
                endGame()
            }
        }
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        if(!tapToStart.inParentHierarchy(self)){
            if(checkSolution(3)){
                setScore()
                arrowObject.removeFromParent()
                newArrow()
            } else {
                endGame()
            }
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
        } else if (rgbw == 4) { //gray
            return false
        } else { //white
            return swiped == spriteNum
        }
    }
    
    func setScore(){
        playSound("correct")
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
        if(currentScore > 75) {
            rgbw = Int(arc4random_uniform(5))
        } else if(currentScore > 45) {
            rgbw = Int(arc4random_uniform(4))
        } else if(currentScore > 25) {
            rgbw = Int(arc4random_uniform(3))
        } else {
            rgbw = Int(arc4random_uniform(2))
        }
        
        let sprite = SKTexture(imageNamed: "arrow_right.png")
        
        arrowObject = NSMovingArrow(size: CGSizeMake(sprite.size().width/18, sprite.size().height/18), sprite: sprite, rgbw: rgbw)
        
        var startPoint = CGPointMake(0, 0)
        
        switch(spriteNum){
        case 0:
            arrowObject.runAction(SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.0))
            break;
        case 1:
            arrowObject.xScale = 1
            break;
        case 2:
            arrowObject.xScale = -1
            break;
        case 3:
            arrowObject.runAction(SKAction.rotateByAngle(CGFloat(-M_PI_2), duration: 0.0))
            break;
        default:
            arrowObject.xScale = 1
            break;
        }
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
    
    func changeFgSpeaker(){
        if let playing = userDefaults.valueForKey("isPlayingFg") {
            if(playing as! NSObject == 1) {
                userDefaults.setValue(0, forKey: "isPlayingFg")
                userDefaults.synchronize()
                fgspeaker.texture = SKTexture(imageNamed: "mute.png")
                isFgPlaying = 0
            } else {
                userDefaults.setValue(1, forKey: "isPlayingFg")
                userDefaults.synchronize()
                fgspeaker.texture = SKTexture(imageNamed: "unmute.png")
                isFgPlaying = 1
            }
        } else {
            userDefaults.setInteger(1, forKey: "isPlayingFg")
        }
        
        fgspeaker.name = "fgspeaker"
        fgspeaker.position = CGPointMake(view!.center.x / 3, 40)
        fgspeaker.size.width = 30
        fgspeaker.size.height = 30
        fgspeaker.zPosition = 100
        fgspeaker.removeFromParent()
        addChild(fgspeaker)
    }
    
    func changeBgSpeaker(){
        if let playing = userDefaults.valueForKey("isPlaying") {
            if(playing as! NSObject == 1) {
                userDefaults.setValue(0, forKey: "isPlaying")
                userDefaults.synchronize()
                bgspeaker.texture = SKTexture(imageNamed: "mutebg.png")
                MusicHelper.sharedHelper.pauseBackgroundMusic()
            } else {
                userDefaults.setValue(1, forKey: "isPlaying")
                userDefaults.synchronize()
                bgspeaker.texture = SKTexture(imageNamed: "unmutebg.png")
                MusicHelper.sharedHelper.resumeBackgroundMusic()
            }
        } else {
            userDefaults.setInteger(1, forKey: "isPlaying")
        }
        
        bgspeaker.name = "speaker"
        bgspeaker.position = CGPointMake(view!.center.x + (view!.center.x / 3)*2, 40)
        bgspeaker.size.width = 30
        bgspeaker.size.height = 30
        bgspeaker.zPosition = 100
        bgspeaker.removeFromParent()
        addChild(bgspeaker)
    }
    
    
    override func didMoveToView(view: SKView) {
        willRunOnce()
        
        if let playing = userDefaults.valueForKey("isPlaying") {
            if(playing as! NSObject == 1) {
                bgspeaker.texture = SKTexture(imageNamed: "unmutebg.png")
                MusicHelper.sharedHelper.resumeBackgroundMusic()
            } else {
                bgspeaker.texture = SKTexture(imageNamed: "mutebg.png")
                MusicHelper.sharedHelper.pauseBackgroundMusic()
            }
        } else {
            userDefaults.setInteger(1, forKey: "isPlaying")
        }
        
        var overlayFgBg = SKSpriteNode()
        overlayFgBg.name = "overlayFg"
        overlayFgBg.position = CGPointMake(view.center.x/3 , 40)
        overlayFgBg.size.width = 50
        overlayFgBg.size.height = 50
        overlayFgBg.zPosition = 99
        overlayFgBg.color = UIColor.clearColor()
        addChild(overlayFgBg)
        
        overlayFgBg = SKSpriteNode()
        overlayFgBg.name = "overlayBg"
        overlayFgBg.position = CGPointMake(view.center.x + (view.center.x / 3)*2, 40)
        overlayFgBg.size.width = 50
        overlayFgBg.size.height = 50
        overlayFgBg.zPosition = 99
        overlayFgBg.color = UIColor.clearColor()
        addChild(overlayFgBg)
        
        overlayInstructions.name = "overlayInstructions"
        overlayInstructions.position = CGPointMake(view.center.x, 40)
        overlayInstructions.size.width = 50
        overlayInstructions.size.height = 50
        overlayInstructions.anchorPoint = CGPointMake(0.5, 0.5)
        overlayInstructions.zPosition = 99
        overlayInstructions.color = UIColor.clearColor()
        addChild(overlayInstructions)
        
        
        howToPlay.name = "howtoplay"
        howToPlay.position = CGPointMake(view.center.x, 40)
        howToPlay.size.width = 30
        howToPlay.size.height = 30
        howToPlay.zPosition = 100
        addChild(howToPlay)
        
        bgspeaker.name = "speaker"
        bgspeaker.position = CGPointMake(view.center.x + (view.center.x / 3)*2, 40)
        bgspeaker.size.width = 30
        bgspeaker.size.height = 30
        bgspeaker.zPosition = 100
        bgspeaker.removeFromParent()
        addChild(bgspeaker)
        
        if let playing = userDefaults.valueForKey("isPlayingFg") {
            if(playing as! NSObject == 1) {
                fgspeaker.texture = SKTexture(imageNamed: "unmute.png")
                isFgPlaying = 1
            } else {
                fgspeaker.texture = SKTexture(imageNamed: "mute.png")
                isFgPlaying = 0
            }
        } else {
            userDefaults.setInteger(1, forKey: "isPlayingFg")
            isFgPlaying = 1
        }
        
        fgspeaker.name = "fgspeaker"
        fgspeaker.position = CGPointMake(view.center.x/3 , 40)
        fgspeaker.size.width = 30
        fgspeaker.size.height = 30
        fgspeaker.zPosition = 100
        fgspeaker.removeFromParent()
        addChild(fgspeaker)
        
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
        var didTap = false
        for var touch in touches {
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
        
            if let name = touchedNode.name {
                if name == "speaker" || name == "overlayBg"{
                    didTap = true
                    changeBgSpeaker()
                    return
                } else if name == "fgspeaker" || name == "overlayFg" {
                    didTap = true
                    changeFgSpeaker()
                } else if name == "howtoplay" || name == "overlayInstructions" {
                    didTap = true
                    let reveal = SKTransition.flipVerticalWithDuration(0.5)
                    let scene = InstructionScene(size: self.size)
                    self.view!.presentScene(scene, transition: reveal)
                    return
                }
            }
        }
        if(tapToStart.inParentHierarchy(self) && !didTap){
            tapToStart.removeFromParent()
            howToPlay.removeFromParent()
            overlayInstructions.removeFromParent()
            newArrow()
            _ =  NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(GameScene.checkCollision), userInfo: nil, repeats: true)
        }

        
    }
    
    func checkCollision(){
        
        if(arrowObject.hasCollided(self.frame.size.width, maxY: self.frame.size.height) && rgbw != 4){
            endGame()
        } else if(arrowObject.hasCollided(self.frame.size.width, maxY: self.frame.size.height) && rgbw == 4){
            setScore()
            arrowObject.removeFromParent()
            newArrow()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func willRunOnce() -> () {
        struct TokenContainer {
            static var token : dispatch_once_t = 0
        }
        
        dispatch_once(&TokenContainer.token) {
            MusicHelper.sharedHelper.playBackgroundMusic()
        }
    }
}
