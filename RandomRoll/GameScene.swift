//
//  GameScene.swift
//  RandomRoll
//
//  Created by Seun Omonije and Emmett 1/15/16.
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


var player : SKSpriteNode!
var playerWalkingFrames: [SKTexture]!

class GameScene: SKScene, SKPhysicsContactDelegate {
    let gameName = SKSpriteNode(imageNamed: "mrrolllogo")
    let background1 = SKSpriteNode(imageNamed: "defaultbackground")
    let background2 = SKSpriteNode(imageNamed: "defaultbackground")
    let background3 = SKSpriteNode(imageNamed: "defaultbackground")
    let cloud = SKSpriteNode(imageNamed: "scrollingclouds")
    let monster = SKSpriteNode(imageNamed: "barrelSprite")
    let button = SKSpriteNode(imageNamed: "projectile")
    let ground = SKSpriteNode()
    var timer = NSTimer()
    var timerLabel = SKLabelNode()
    var seconds:Int = 0
    var startLabel = SKSpriteNode(imageNamed: "StartButton")
    let label = SKSpriteNode(imageNamed: "RestartButton")
    let endScore = SKLabelNode(fontNamed: "Helvetica")
    var canJump = 1
    var dead = false
    var onStartScreen = true
    
    
    
  
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        self.view!.backgroundColor = UIColor(patternImage: UIImage(named: "defaultbackground")!)
        //makes sprite appear on the scene
        addPlayer()
        addGround()
        labelStart()
        backgroundSetUp()
        gameNameSetUp()
        walkingPlayer()
        dead = false

    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //basically my tap to start feature. i set the player's dynamic to false at the play screen, then on the first tap it runs the game, then every other tap it normally jumps
        if dead == true {
            goToGameScene()
            onStartScreen = true
            dead = false
        }
        if canJump == 2 {
            player.physicsBody?.dynamic = true
            player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 150.0))
             physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.5)
            canJump = 1
        } else if dead == false && onStartScreen {
            startGame()
            physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
            dead = false
            onStartScreen = false
        } else if canJump == 1 {
            player.physicsBody?.dynamic = true
        }
        
    
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        player.physicsBody?.dynamic = true
        let jumpHighest = SKAction.runBlock({player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 10.0))})
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.9)
        let jumpHighestAction = SKAction.sequence([jumpHighest, SKAction.waitForDuration(3.0)])
        
        if actionForKey("yeetyah") == nil {
            runAction(jumpHighestAction, withKey: "yeetyah")
        }

     
    }
   override func update(currentTime: NSTimeInterval) {
        background1.position = CGPoint(x: background1.position.x - 4, y: background1.position.y)
        background2.position = CGPoint(x: background2.position.x - 4, y: background2.position.y)
    
        if (background1.position.x < -background1.size.width){
            background1.position = CGPointMake(background2.position.x + background2.size.width, background1.position.y)
        }
        
        if background2.position.x < -background2.size.width {
            background2.position = CGPointMake(background1.position.x + background1.size.width, background2.position.y)
        }
    
    }
    func gameNameSetUp(){
        gameName.position = CGPoint(x: size.width/2, y: size.height / 1.2)
        let fractionsize = size.width / 1.1
        gameName.size = CGSize(width: fractionsize, height : fractionsize / 5.22)
        addChild(gameName)
    }
    func backgroundSetUp() {
        let fraction = size.height * (8/3)
        background1.anchorPoint = CGPointZero
        background1.position = CGPointMake(0,0)
        background1.size = CGSize(width: fraction , height: size.height)
        background1.zPosition = -2
        addChild(background1)
        
        background2.anchorPoint = CGPointZero
        background2.position = CGPointMake(background2.size.width - 1, 0)
        background2.size = CGSize(width: fraction , height: size.height)
        background2.zPosition = -1
        addChild(background2)
        
        background3.anchorPoint = CGPointZero
        background3.position = CGPointMake(0, 0)
        background3.size = CGSize(width: fraction , height: size.height)
        background3.zPosition = -3
        addChild(background3)
    }
    
    func startGame(){
        spawnBarrels()
        addTimer()
        runScore()
        startLabel.runAction(SKAction.fadeOutWithDuration(0.5))
        gameName.runAction(SKAction.fadeOutWithDuration(0.5))
        player.physicsBody?.dynamic = true
        dead = false
        onStartScreen = false
        canJump = 1
    }
   
    func goToGameScene(){
        removeAllChildren()
        removeAllActions()
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size)
        let transition = SKTransition.fadeWithDuration(1.0)
        gameScene.scaleMode=SKSceneScaleMode.Fill
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    
    
    func labelStart(){
        startLabel.size = CGSize(width: 200 , height: 233.3333)
        startLabel.position = CGPoint(x: size.width/2, y: size.height/1.8)
        addChild(startLabel)
    }
    func addTimer(){
        addChild(timerLabel)
        timerLabel.runAction(SKAction.fadeInWithDuration(0.5))
        timerLabel.fontColor = UIColor.whiteColor()
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
        //player animation
        let playerAnimatedAtlas = SKTextureAtlas(named: "BearImages")
        var walkFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for var i = 1; i <= numImages/1; i++ {
            let playerTextureName = "frame-\(i)"
            walkFrames.append(playerAnimatedAtlas.textureNamed(playerTextureName))
        }
        playerWalkingFrames = walkFrames
        
        let firstFrame = playerWalkingFrames[0]
        player = SKSpriteNode(texture: firstFrame)
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.235)
        player.size = CGSize(width: 35, height: 51)
        
        //sets up the physics world to have no gravity
       
        //sets the scene to be notified when two physics bodies collide
        physicsWorld.contactDelegate = self
        //creates a player physics body
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        //sets the player to dynamic
        player.physicsBody?.dynamic = false
        //no rotation
        player.physicsBody?.allowsRotation = false
        //therest
        player.physicsBody?.mass = 1.0
        player.physicsBody?.restitution = 0.999
        player.physicsBody?.friction = 1.0
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
        
        addChild(player)
        
    }
    func walkingPlayer(){
        player.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(playerWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "walkingInPlacePlayer")
    }
    func spawnBarrels(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addMonster), SKAction.waitForDuration(2.0)])))
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
        
        let monster = SKSpriteNode(imageNamed: "barrelSprite")
        //determine where to spawn monster along the y axis
         let actualY = size.height * 0.223
        
        //position monster slightly off screen along the right edge
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        monster.size = CGSize(width: 25, height: 25)
        
        //add monster
        addChild(monster)
        
        //Determine speed of the monster
        let actualDuration = random(min: CGFloat(3), max: CGFloat(11))
        
        //create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration:NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        //creates the physicsBody for the monster
        monster.physicsBody = SKPhysicsBody(circleOfRadius: monster.size.width/1.6)
        
        //sets the sprite to dynamic
        monster.physicsBody?.dynamic = false
        
        //sets the category bit mask to be monster category
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        
        //indicates what category
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
        //stops bouncing off
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        monster.runAction(SKAction.repeatActionForever(rotate))
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]), withKey: "barrels")
    }
    func addGround(){
        addChild(ground)
        ground.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: 0, y: size.height * 0.225), toPoint: CGPoint(x: size.width, y: size.height * 0.225))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.restitution = 1
        ground.physicsBody?.angularDamping = 0.0
        ground.physicsBody?.linearDamping = 0.0
        //sets the category bit mask to be ground category
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        
        //indicates what category
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.Player
  
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
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ground != 0)) {
                player.physicsBody?.resting = true
                 physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
                canJump = 2
                
        }

        func playerDidCollideWithMonster(projectile:SKSpriteNode, player:SKSpriteNode){
            print("Hit")
            projectile.removeFromParent()
            player.removeFromParent()
            
            endScore.text = "\(seconds)"
            label.position = CGPoint(x: size.width/2, y: size.height/1.5)
            label.size = CGSize(width: 200, height: 233.33333)
            endScore.fontSize = 30
            endScore.fontColor = SKColor.blackColor()
            endScore.position = CGPoint(x: size.width/2, y: size.height/1.1)
            removeActionForKey("yeet")
            removeActionForKey("barrels")
            addChild(label)
            addChild(endScore)
            timerLabel.removeFromParent()
            dead = true

            
            
        }
        //checks to see if the two bodies that collide are the projectile and monster, and if so calls the method
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            playerDidCollideWithMonster(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
                
        }
    }
}


