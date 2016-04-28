//
//  GameViewController.swift
//  RandomRoll
//
//  Created by Seun Omonije on 1/15/16.
//  Copyright (c) 2016 Seun Omonije. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    var generator = [6, 12, 8].generate()
    //sprite set up
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size:view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        
        
           }
        //hides status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}
