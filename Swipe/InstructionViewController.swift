//
//  GameViewController.swift
//  Arrow
//
//  Created by Nami Shah on 09/04/16.
//  Copyright (c) 2016 Nami Shah. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(InstructionViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.performSegueWithIdentifier("pushGame", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
