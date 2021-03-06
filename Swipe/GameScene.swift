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
    var highscore = UserDefaults.standard.integer(forKey: "highscore")
    var isFgPlaying = UserDefaults.standard.integer(forKey: "isPlayingFg")
    var gameOver = false
    
    var scoreLabel:SKLabelNode!
    var highscoreLabel:SKLabelNode!
    let tapToStart = SKLabelNode(fontNamed: "DIN Condensed")
    
    var overlayLB = SKSpriteNode()
    var overlayBS = SKSpriteNode()
    var overlayFS = SKSpriteNode()
    var overlayII = SKSpriteNode()
    
    var sound = AVAudioPlayer()
    
    let bgspeaker = SKSpriteNode(texture: SKTexture(imageNamed: "unmutebg.png"))
    let fgspeaker = SKSpriteNode(texture: SKTexture(imageNamed: "unmute.png"))
    let howToPlay = SKSpriteNode(texture: SKTexture(imageNamed: "InstructionIcon.png"))
    let leaderboardIcon = SKSpriteNode(texture: SKTexture(imageNamed: "highscore.png"))
    let title = SKSpriteNode(texture: SKTexture(imageNamed: "title.png"))
    
    let userDefaults = UserDefaults.standard
    
    var wOdds: Int!
    var rOdds: Int!
    var blOdds: Int!
    var gOdds: Int!
    var grOdds: Int!
    
    
    func playSound(soundName: String)
    {
        if(isFgPlaying == 1 && !gameOver) {
            let coinSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
            do{
                sound = try AVAudioPlayer(contentsOf:coinSound as URL)
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
            playSound(soundName: "wrong")
            removeAllChildren()
            gameOver = true
            if (UserDefaults.standard.value(forKey: "lastscore") != nil) {
                UserDefaults.standard.set(currentScore, forKey: "lastscore")
                UserDefaults.standard.synchronize()
            } else {
                userDefaults.set(currentScore, forKey: "lastscore")
            }
            var c: UIColor
            if(rgbw == 1){ //red
                c = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            } else if(rgbw == 2) { //blue
                c = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
            } else if(rgbw == 3) { //green
                c = UIColor(red: 42/255, green: 187/255, blue: 155/255, alpha: 1)
            } else if(rgbw == 4) { //Gray
                c = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
            } else { //white
                c = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
            }
            let reveal = SKTransition.fade(with: c, duration: 0.5)
            let scene = GameOverScene(size: self.size, cs: currentScore, hs: highscore)
            self.view!.presentScene(scene, transition: reveal)
            if (FBSDKAccessToken.current() != nil) {
                var myScore = 0
                let request = FBSDKGraphRequest(graphPath:"me", parameters:["fields": "scores"]);
                request?.start { (connection, result, error) -> Void in
                    if error == nil {
                        var results = result as? AnyObject
                        if ((results?.value(forKey: "scores") as AnyObject).value(forKey: "data")) != nil {
                            let object = (results?.value(forKey: "scores") as AnyObject).value(forKey: "data") as! [NSDictionary]
                            for ob in object {
                                myScore = ob.value(forKey: "score") as! Int
                                if(myScore < self.highscore) {
                                    self.publishScoreToFacebook()
                                }
                            }
                        }
                    } else {
                        print("Error Getting Me \(error)");
                    }
                }
            }
        }
    }
    
    
    func publishScoreToFacebook(){
        if (FBSDKAccessToken.current() != nil) {
            let params: [String : String] = ["score": "\(highscore)"]
            /* make the API call */
            let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/scores", parameters: params, httpMethod: "POST")
            request.start { (connection, result, error) -> Void in
                if error == nil {
                    print("Successfully published score!")
                } else {
                    print("Error Publishing Score: \(error)");
                }
            }
        }
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        if(!tapToStart.inParentHierarchy(self)){
            if(checkSolution(swiped: 0)){
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
            if(checkSolution(swiped: 1)){
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
            if(checkSolution(swiped: 2)){
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
            if(checkSolution(swiped: 3)){
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
        playSound(soundName: "correct")
        currentScore += 1
        let userDefaults = UserDefaults.standard
        if let hs = userDefaults.value(forKey: "highscore") {
            if(currentScore > hs as! Int){
                highscore = currentScore
                userDefaults.setValue(highscore, forKey: "highscore")
                userDefaults.synchronize()
            }
        } else {
            userDefaults.set(currentScore, forKey: "highscore")
        }
        
        scoreLabel.text = "\(currentScore)"
        highscoreLabel.text = "\(highscore)"
    }
    
    
    func calcSpeedForScore() -> Double{
        return (currentScore >= 55) ? 1.25 : (4 - (Double(currentScore)/20))
    }
    
    func calculateOdds() {
        if(currentScore <= 50) {
            wOdds = 50 - (abs(50 - 20) / 50) * currentScore
            rOdds = 40 - (abs(40 - 20) / 50) * currentScore
            blOdds = 10 + (abs(10 - 20) / 50) * currentScore
            gOdds = 5 + (abs(5 - 20) / 50) * currentScore
            grOdds = 2 + (abs(2 - 20) / 50) * currentScore
        } else {
            wOdds = 20
            rOdds = 20
            blOdds = 20
            gOdds = 20
            grOdds = 5
        }
    }
    
    func getOdds(random: Int) -> Int{
        if(random < wOdds) {
            return 0
        } else if(random < (wOdds + rOdds)) {
            return 1
        } else if(random < (wOdds + rOdds + blOdds)) {
            return 2
        } else if(random < (wOdds + rOdds + blOdds + gOdds)) {
            return 3
        } else if(random < (wOdds + rOdds + blOdds + gOdds + grOdds)) {
            return 4
        } else {
            return 0
        }
    }
    
    
    func newArrow(){
        spriteNum = Int(arc4random_uniform(4))
        dirNum = Int(arc4random_uniform(4))
        calculateOdds()
        var totalOdds: Int
        totalOdds = (wOdds + rOdds + blOdds + gOdds + grOdds + 1)
        let rand = Int(arc4random_uniform(UInt32(totalOdds)))
        rgbw = getOdds(random: rand)
        
        let sprite = SKTexture(imageNamed: "arrow_right.png")
        
        arrowObject = NSMovingArrow(size: CGSize(width: sprite.size().width/18, height: sprite.size().height/18), sprite: sprite, rgbw: rgbw)
        
        var startPoint = CGPoint(x: 0, y: 0)
        
        switch(spriteNum){
        case 0:
            arrowObject.run(SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 0.0))
            break;
        case 1:
            arrowObject.xScale = 1
            break;
        case 2:
            arrowObject.xScale = -1
            break;
        case 3:
            arrowObject.run(SKAction.rotate(byAngle: CGFloat(-Double.pi/2), duration: 0.0))
            break;
        default:
            arrowObject.xScale = 1
            break;
        }
        switch(dirNum){
        case 0: //Up
            startPoint = CGPoint(x: view!.center.x, y: 0)
            break;
        case 1: //Right
            startPoint = CGPoint(x: 0, y: view!.center.y)
            break;
        case 2: //Left
            startPoint = CGPoint(x: self.frame.size.width, y: view!.center.y)
            break;
        case 3: //Down
            startPoint = CGPoint(x: view!.center.x, y: self.frame.size.height)
            break;
        default: //Right
            startPoint = CGPoint(x: 0, y: view!.center.y)
            break;
        }
        
        arrowObject.position = startPoint
        addChild(arrowObject)
        arrowObject.start(direction: dirNum, maxX: self.frame.size.width, maxY: self.frame.size.height, duration: calcSpeedForScore())
    }
    
    func changeFgSpeaker(){
        if let playing = userDefaults.value(forKey: "isPlayingFg") as? NSNumber {
            if(playing == 1) {
                userDefaults.set(0, forKey: "isPlayingFg")
                userDefaults.synchronize()
                fgspeaker.texture = SKTexture(imageNamed: "mute.png")
                isFgPlaying = 0
            } else {
                userDefaults.set(1, forKey: "isPlayingFg")
                userDefaults.synchronize()
                fgspeaker.texture = SKTexture(imageNamed: "unmute.png")
                isFgPlaying = 1
            }
        } else {
            userDefaults.set(1, forKey: "isPlayingFg")
        }
        
        fgspeaker.name = "fgspeaker"
        fgspeaker.size.width = 35
        fgspeaker.size.height = 35
        fgspeaker.zPosition = 100
        fgspeaker.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        fgspeaker.position = CGPoint(x: ((3/4) * self.frame.size.width) - (fgspeaker.size.width+5) , y: 40)
        fgspeaker.removeFromParent()
        addChild(fgspeaker)
    }
    
    func changeBgSpeaker(){
        if let playing = userDefaults.value(forKey: "isPlaying")  as? NSNumber {
            if(playing == 1) {
                userDefaults.setValue(0, forKey: "isPlaying")
                userDefaults.synchronize()
                bgspeaker.texture = SKTexture(imageNamed: "mutebg.png")
                MusicHelper.sharedHelper.pauseBackgroundMusic()
            } else {
                userDefaults.set(1, forKey: "isPlaying")
                userDefaults.synchronize()
                bgspeaker.texture = SKTexture(imageNamed: "unmutebg.png")
                MusicHelper.sharedHelper.resumeBackgroundMusic()
            }
        } else {
            userDefaults.set(1, forKey: "isPlaying")
        }
        
        bgspeaker.name = "speaker"
        bgspeaker.size.width = 35
        bgspeaker.size.height = 35
        bgspeaker.zPosition = 100
        bgspeaker.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bgspeaker.position = CGPoint(x: ((4/4) * self.frame.size.width) - (bgspeaker.size.width+5), y: 40)
        bgspeaker.removeFromParent()
        addChild(bgspeaker)
    }
    
    
    override func didMove(to view: SKView) {
        willRunOnce()
        
        if let playing = userDefaults.value(forKey: "isPlaying") as? NSNumber {
            if(playing == 1) {
                bgspeaker.texture = SKTexture(imageNamed: "unmutebg.png")
                MusicHelper.sharedHelper.resumeBackgroundMusic()
            } else {
                bgspeaker.texture = SKTexture(imageNamed: "mutebg.png")
                MusicHelper.sharedHelper.pauseBackgroundMusic()
            }
        } else {
            userDefaults.set(1, forKey: "isPlaying")
        }
        
        if let playing = userDefaults.value(forKey: "isPlayingFg") as? NSNumber {
            if(playing == 1) {
                fgspeaker.texture = SKTexture(imageNamed: "unmute.png")
                isFgPlaying = 1
            } else {
                fgspeaker.texture = SKTexture(imageNamed: "mute.png")
                isFgPlaying = 0
            }
        } else {
            userDefaults.set(1, forKey: "isPlayingFg")
            isFgPlaying = 1
        }
        
        leaderboardIcon.name = "leaderboard"
        leaderboardIcon.size.width = 35
        leaderboardIcon.size.height = 35
        leaderboardIcon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        leaderboardIcon.zPosition = 100
        leaderboardIcon.position = CGPoint(x: ((1/4) * self.frame.size.width) - (leaderboardIcon.size.width+5), y: 40)
        addChild(leaderboardIcon)
        
        howToPlay.name = "howtoplay"
        howToPlay.size.width = 35
        howToPlay.size.height = 35
        howToPlay.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        howToPlay.zPosition = 100
        howToPlay.position = CGPoint(x: ((2/4) * self.frame.size.width) - (howToPlay.size.width+5), y: 40)
        addChild(howToPlay)
        
        fgspeaker.name = "fgspeaker"
        fgspeaker.size.width = 35
        fgspeaker.size.height = 35
        fgspeaker.zPosition = 100
        fgspeaker.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        fgspeaker.position = CGPoint(x: ((3/4) * self.frame.size.width) - (fgspeaker.size.width+5) , y: 40)
        fgspeaker.removeFromParent()
        addChild(fgspeaker)
        
        bgspeaker.name = "speaker"
        bgspeaker.size.width = 35
        bgspeaker.size.height = 35
        bgspeaker.zPosition = 100
        bgspeaker.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bgspeaker.position = CGPoint(x: ((4/4) * self.frame.size.width) - (bgspeaker.size.width+5), y: 40)
        bgspeaker.removeFromParent()
        addChild(bgspeaker)
        
        
        overlayFS = SKSpriteNode()
        overlayFS.name = "overlayFg"
        overlayFS.position = CGPoint(x: ((3/4) * self.frame.size.width) - (fgspeaker.size.width+5), y: 40)
        overlayFS.size.width = 75
        overlayFS.size.height = 75
        overlayFS.zPosition = 99
        overlayFS.color = UIColor.clear
        addChild(overlayFS)
        
        overlayBS = SKSpriteNode()
        overlayBS.name = "overlayBg"
        overlayBS.position = CGPoint(x: ((4/4) * self.frame.size.width) - (bgspeaker.size.width+5), y: 40)
        overlayBS.size.width = 75
        overlayBS.size.height = 75
        overlayBS.zPosition = 99
        overlayBS.color = UIColor.clear
        addChild(overlayBS)
        
        overlayII = SKSpriteNode()
        overlayII.name = "overlayInstructions"
        overlayII.position = CGPoint(x: ((2/4) * self.frame.size.width) - (howToPlay.size.width+5), y: 40)
        overlayII.size.width = 75
        overlayII.size.height = 75
        overlayII.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        overlayII.zPosition = 99
        overlayII.color = UIColor.clear
        addChild(overlayII)
        
        overlayLB = SKSpriteNode()
        overlayLB.name = "overlayLeaderboard"
        overlayLB.position = CGPoint(x: ((1/4) * self.frame.size.width) - (leaderboardIcon.size.width+5), y: 40)
        overlayLB.size.width = 75
        overlayLB.size.height = 75
        overlayLB.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        overlayLB.zPosition = 99
        overlayLB.color = UIColor.clear
        addChild(overlayLB)
        
        //let appDomain = NSBundle.mainBundle().bundleIdentifier!
        //NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        backgroundColor = UIColor(red: 44/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1)
        
        scoreLabel = SKLabelNode(fontNamed: "DIN Condensed")
        scoreLabel.text = "\(UserDefaults.standard.value(forKey: "lastscore"))"
        scoreLabel.fontSize = 30
        scoreLabel.color = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        scoreLabel.position = CGPoint(x: view.center.x / 3, y: self.frame.size.height - 40)
        
        addChild(scoreLabel)
        
        highscoreLabel = SKLabelNode(fontNamed: "DIN Condensed")
        highscoreLabel.text = "\(highscore)"
        highscoreLabel.fontSize = 30
        highscoreLabel.color = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        highscoreLabel.position = CGPoint(x: view.center.x + (view.center.x / 3)*2, y: self.frame.size.height - 40)
        
        addChild(highscoreLabel)
        
        title.name = "title"
        title.size.width = 150
        title.size.height = 150
        title.zPosition = 100
        title.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        title.position = CGPoint(x: view.center.x, y: view.center.y + (view.center.y / 2.5))
        title.removeFromParent()
        addChild(title)
        
        tapToStart.text = "Tap to start"
        tapToStart.color = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
        tapToStart.fontSize = 35
        tapToStart.position = CGPoint(x: view.center.x, y: view.center.y - (view.center.y/6))
        tapToStart.name = "taptostart"
        addChild(tapToStart)
        
        /* Setup your scene here */
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        var didTap = false
        for var touch in touches {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
        
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
                    let reveal = SKTransition.flipVertical(withDuration: 0.5)
                    let scene = InstructionScene(size: self.size)
                    self.view!.presentScene(scene, transition: reveal)
                    return
                } else if name == "leaderboard" || name == "overlayLeaderboard" {
                    didTap = true
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeaderBoard") as UIViewController
                    self.view!.window!.rootViewController!.present(viewController, animated: true, completion: nil)
                    
                    //self.view!.window!.rootViewController!.performSegueWithIdentifier("pushLeaderboard", sender: self)
                    return
                }
            }
        }
        
        if(tapToStart.inParentHierarchy(self) && !didTap){
            title.removeFromParent()
            tapToStart.removeFromParent()
            howToPlay.removeFromParent()
            fgspeaker.removeFromParent()
            bgspeaker.removeFromParent()
            leaderboardIcon.removeFromParent()
            overlayLB.removeFromParent()
            overlayBS.removeFromParent()
            overlayFS.removeFromParent()
            overlayII.removeFromParent()
            scoreLabel.text = "0"
            newArrow()
            _ =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.checkCollision), userInfo: nil, repeats: true)
        }

        
    }
    
    func checkCollision(){
        
        if(arrowObject.hasCollided(maxX: self.frame.size.width, maxY: self.frame.size.height) && rgbw != 4){
            endGame()
        } else if(arrowObject.hasCollided(maxX: self.frame.size.width, maxY: self.frame.size.height) && rgbw == 4){
            setScore()
            arrowObject.removeFromParent()
            newArrow()
        }
    }
   
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func willRunOnce() -> () {
        DispatchQueue.once(token: "0")  {
            let userDefaults = UserDefaults.standard
            if userDefaults.value(forKey: "highscore") != nil {
                //
            } else {
                userDefaults.set(0, forKey: "highscore")
            }
            MusicHelper.sharedHelper.playBackgroundMusic()
        }
    }
}


public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
