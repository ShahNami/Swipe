//
//  MusicHelper.swift
//  Swipe
//
//  Created by Nami Shah on 14/04/16.
//  Copyright © 2016 Nami Shah. All rights reserved.
//

import Foundation
import AVFoundation

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "theme", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.volume = 0.05
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
    
    func resumeBackgroundMusic(){
        audioPlayer!.play()
    }
    
    func pauseBackgroundMusic(){
        audioPlayer!.pause()
    }
}
