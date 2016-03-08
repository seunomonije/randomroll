//
//  GameScene.swift
//  RandomRoll
//
//  Created by Seun Omonije on 1/15/16.
//  Copyright (c) 2016 Seun Omonije. All rights reserved.
//

import SpriteKit

struct PhysicsCategory{
    static let None      :UInt32 = 0
    static let All       :UInt32 = UInt32.max
    static let Monster   :UInt32 = 0b1
    static let Player    :UInt32 = 0b10
    static let Ground    :UInt32 = 0b100
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let background1 = SKSpriteNode(imageNamed: "bg1")
    let cloud = SKSpriteNode(imageNamed: "scrollingclouds")
    let player = SKSpriteNode(imageNamed: "player")
    let button = SKSpriteNode(imageNamed: "projectile")
    let ground = SKSpriteNode(imageNamed: "xgqFk")
    var timer = NSTimer()
    var timerLabel = SKLabelNode()
    var seconds:Int = 0
    var startLabel = SKLabelNode()
    var dead = 0
    

    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        backgroundColor = UIColor.whiteColor()
        //makes sprite appear on the scene
        addPlayer()
        addGround()
        labelStart()
        
        

    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if player.physicsBody!.dynamic {
            player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 5.0))
        } else {
        spawnBarrels()
        addTimer()
        runScore()
        startLabel.removeFromParent()
        player.physicsBody?.dynamic = true
        player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 4.0))
        }
    }
    func startGame(){
        spawnBarrels()
        addTimer()
        runScore()
        startLabel.removeFromParent()
        player.physicsBody?.dynamic = true
    }

    func labelStart(){
        startLabel.text = "Tap"
        startLabel.fontSize = 30
        startLabel.fontColor = UIColor.blackColor()
        startLabel.position = CGPoint(x: 150, y: 200)
        addChild(startLabel)
    }
    func addTimer(){
        addChild(timerLabel)
        timerLabel.fontColor = UIColor.blackColor()
        timerLabel.fontSize = 20
        timerLabel.fontName = "HelveticaNeue-Bold"
        timerLabel.position = CGPoint(x: size.width * 0.08, y: size.height * 0.95)
        timerLabel.text = "\(seconds)"
    }
    
    
    
    func updateScoreWithValue (value: Int) {
        seconds += value
        timerLabel.text = "\(seconds)"
    }
    func updateScore(){
        updateScoreWithValue(1)
        timerLabel.text = "\(seconds)"
    }
    func runScore(){
            let scoreAction = SKAction.sequence([SKAction.runBlock(updateScore), SKAction.waitForDuration(0.5)])
        runAction(SKAction.repeatActionForever(scoreAction), withKey:"yeet")
            timerLabel.text = "\(seconds)"
    }
 
    func addPlayer(){
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.15)
        addChild(player)
        //sets up the physics world to have no gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        //sets the scene to be notified when two physics bodies collide
        physicsWorld.contactDelegate = self
        //creates a player physics body
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        //sets the player to dynamic
        player.physicsBody?.dynamic = false
        //no rotation
        player.physicsBody?.allowsRotation = false
        //therest
        player.physicsBody?.restitution = 1.0
        player.physicsBody?.friction = 0.0
        player.physicsBody?.angularDamping = 0.0
        player.physicsBody?.linearDamping = 0.0
        //sets categorybitmask
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        //indicates category
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        //no bouncing off
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        //collision detection
        player.physicsBody?.usesPreciseCollisionDetection = true

    }
    func spawnBarrels(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addMonster), SKAction.waitForDuration(4.0)])))
    }
    //code for random number generation
    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    // adding the monster code
    func addMonster(){
        //creates the sprite
        let monster = SKSpriteNode(imageNamed: "barrelSprite")
        
        //determine where to spawn monster along the y axis
        _ = 50
        
        //position monster slightly off screen along the right edge
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: size.height * 0.15)
        
        //add monster
        addChild(monster)
        
        //Determine speed of the monster
        let actualDuration = random(min: CGFloat(10), max: CGFloat(11))
        
        //create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: size.height * 0.15), duration:NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        //creates the physicsBody for the monster
        monster.physicsBody = SKPhysicsBody(circleOfRadius: monster.size.width/2)
        
        //sets the sprite to dynamic
        monster.physicsBody?.dynamic = false
        
        //sets the category bit mask to be monster category
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        
        //indicates what category
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
        //stops bouncing off
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    func addGround(){
        addChild(ground)
        ground.size = CGSize(width: size.width * 1, height: size.height * 0.1)
        ground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.05)
        
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: size.height, height: size.height * 0.1))
        
        ground.physicsBody?.dynamic = false
    }
    
    var canJump = true
    
    func didBeginContactGround(contact: SKPhysicsContact){
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch(contactMask){
        case PhysicsCategory.Player | PhysicsCategory.Ground:
            canJump = true
        default:
            return
        }
    }

    func didBeginContact(contact: SKPhysicsContact) {
        //passes when the two bodies collide, but doesn't guarantee that they are passed in any order, basically arranges the code
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        func playerDidCollideWithMonster(projectile:SKSpriteNode, player:SKSpriteNode){
            print("Hit")
            projectile.removeFromParent()
            player.removeFromParent()
            let label = SKLabelNode(fontNamed: "Chalkduster")
            label.text = "GAME OVER"
            label.fontSize = 20
            label.fontColor = SKColor.blackColor()
            label.position = CGPoint(x: size.width/2, y: size.height/2)
            removeActionForKey("yeet")
            addChild(label)
            

            
            
        }
        //checks to see if the two bodies that collide are the projectile and monster, and if so calls the method
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            playerDidCollideWithMonster(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
                
        }
    }
}


