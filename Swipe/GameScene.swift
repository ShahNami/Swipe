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
    var gameOver = false
    
    var scoreLabel:SKLabelNode!
    var highscoreLabel:SKLabelNode!
    let tapToStart = SKLabelNode(fontNamed: "DIN Condensed")
    let instruction1 = SKSpriteNode(imageNamed: "WhiteSwipe.png")
    let instruction2 = SKSpriteNode(imageNamed: "RedSwipe.png")
    let instruction3 = SKSpriteNode(imageNamed: "BlueSwipe.png")
    let instruction4 = SKSpriteNode(imageNamed: "GreenSwipe.png")
    let instruction5 = SKSpriteNode(imageNamed: "GraySwipe.png")
    
    var sound = AVAudioPlayer()
    let speaker = SKSpriteNode(texture: SKTexture(imageNamed: "unmute.png"))
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    func playSound(soundName: String)
    {
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
    
    func changeSpeaker(){
        if let playing = userDefaults.valueForKey("isPlaying") {
            if(playing as! NSObject == 1) {
                userDefaults.setValue(0, forKey: "isPlaying")
                userDefaults.synchronize()
                speaker.texture = SKTexture(imageNamed: "mute.png")
                MusicHelper.sharedHelper.pauseBackgroundMusic()
            } else {
                userDefaults.setValue(1, forKey: "isPlaying")
                userDefaults.synchronize()
                speaker.texture = SKTexture(imageNamed: "unmute.png")
                MusicHelper.sharedHelper.resumeBackgroundMusic()
            }
        } else {
            userDefaults.setInteger(1, forKey: "isPlaying")
        }
        
        speaker.name = "speaker"
        speaker.position = CGPointMake(view!.center.x, self.frame.size.height - 30)
        speaker.size.width = 30
        speaker.size.height = 30
        speaker.zPosition = 100
        speaker.removeFromParent()
        addChild(speaker)
    }
    
    
    override func didMoveToView(view: SKView) {
        
        
        instruction1.position = CGPointMake((view.center.x / 2), view.center.y - (view.center.y / 3))
        instruction1.size.width = 65
        instruction1.size.height = 65
        addChild(instruction1)
        
        instruction2.position = CGPointMake(view.center.x + (view.center.x / 2), view.center.y - (view.center.y / 3))
        instruction2.size.width = 65
        instruction2.size.height = 65
        addChild(instruction2)
        
        instruction3.position = CGPointMake(view.center.x + (view.center.x / 2), view.center.y - (view.center.y /  1.5))
        instruction3.size.width = 65
        instruction3.size.height = 65
        addChild(instruction3)
        
        instruction4.position = CGPointMake((view.center.x / 2), view.center.y - (view.center.y /  1.5))
        instruction4.size.width = 65
        instruction4.size.height = 65
        addChild(instruction4)
        
        instruction5.position = CGPointMake(view.center.x, view.center.y - (view.center.y / 2))
        instruction5.size.width = 65
        instruction5.size.height = 65
        addChild(instruction5)
        
        willRunOnce()
        
        if let playing = self.userDefaults.valueForKey("isPlaying") {
            if(playing as! NSObject == 1) {
                self.speaker.texture = SKTexture(imageNamed: "unmute.png")
                MusicHelper.sharedHelper.resumeBackgroundMusic()
            } else {
                self.speaker.texture = SKTexture(imageNamed: "mute.png")
                MusicHelper.sharedHelper.pauseBackgroundMusic()
            }
        } else {
            self.userDefaults.setInteger(1, forKey: "isPlaying")
        }
        
        self.speaker.name = "speaker"
        self.speaker.position = CGPointMake(self.view!.center.x, self.frame.size.height - 30)
        self.speaker.size.width = 30
        self.speaker.size.height = 30
        self.speaker.zPosition = 100
        self.speaker.removeFromParent()
        self.addChild(self.speaker)
        
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
        for var touch in touches {
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
        
            if let name = touchedNode.name {
                if name == "speaker" {
                    changeSpeaker()
                    return
                }
            }
        }
        if(tapToStart.inParentHierarchy(self)){
            tapToStart.removeFromParent()
            instruction1.removeFromParent()
            instruction2.removeFromParent()
            instruction3.removeFromParent()
            instruction4.removeFromParent()
            instruction5.removeFromParent()
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
