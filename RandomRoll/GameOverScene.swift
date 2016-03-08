//
//  GameOverScene.swift
//  RandomRoll
//
//  Created by Seun Omonije on 2/3/16.
//  Copyright © 2016 Seun Omonije. All rights reserved.
//
import SpriteKit
import Foundation
let monster = SKSpriteNode(imageNamed: "barrelSprite")
let player = SKSpriteNode(imageNamed: "player")

class GameOverScene: SKScene {
    init(size: CGSize, won:Bool) {
        super.init(size: size)

        //either says won or lost
        let message = won ? "You Won!" : "You lose! :["

//puts you lose on screen
    print("OH MY GOD I DIED")
    monster.removeFromParent()
    player.removeFromParent()
    let label = SKLabelNode(fontNamed: "Chalkduster")
    label.text = "GAME OVER"
    label.fontSize = 20
    label.fontColor = SKColor.blackColor()
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(label)

//sets up the sequence
runAction(SKAction.sequence([
    SKAction.waitForDuration(2.0),
    SKAction.runBlock() {
//transitions scene
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition:reveal)
      }
    ]))
        
    }

//dummy implementation
required init(coder aDecoder : NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}