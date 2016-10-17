//
//  GameScene.swift
//  screenShooter
//
//  Created by samraj on 8/31/16.
//  Copyright (c) 2016 Samraj. All rights reserved.
//

import SpriteKit
var direction = "right"
let sprite = SKSpriteNode(imageNamed:"Ship")

var height = 0
var width = 0

var screenHeight: CGFloat = 0
var screenWidth: CGFloat = 0


var score: Int = 0
let myLabel = SKLabelNode(fontNamed:"Helvetica")

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10
    static let Ship      : UInt32 = 0b100 // 2
}

class GameScene: SKScene , SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        
        screenWidth = self.size.width
        screenHeight = self.size.height
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/15)
        sprite.physicsBody?.dynamic = true
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Ship
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.None
        sprite.physicsBody?.usesPreciseCollisionDetection = true
        sprite.physicsBody?.affectedByGravity = false
        sprite.position.x = self.size.width/2
        sprite.position.y = self.size.height/2
        speed = 3
        myLabel.fontSize = 20
        myLabel.fontColor = NSColor.whiteColor()
        myLabel.position = CGPoint(x:self.frame.width - 90, y:self.frame.height - 100)
        self.addChild(myLabel)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        let rect = SKShapeNode(rectOfSize: CGSize(width: 100, height: 30))
        rect.name = "Score"
        rect.fillColor = SKColor.lightGrayColor()
        rect.position = CGPoint(x:self.frame.width - 90, y:self.frame.height - 93 )
        
        self.addChild(rect)
        
       
        self.view?.allowsTransparency = true
        self.backgroundColor = NSColor.clearColor()
        sprite.size = CGSize(width: 60, height: 60)
        
        
        self.addChild(sprite)
        
        
        
        let action = SKAction.rotateByAngle(CGFloat(3*M_PI/2) , duration: 0)
        sprite.runAction(action)

        self.view?.window?.titleVisibility = NSWindowTitleVisibility.Hidden
        self.view?.window?.titlebarAppearsTransparent = true
        
        height =  Int(self.view!.frame.height) - 50
        width =  Int(self.view!.frame.width) - 50
        
       
    
        spawnAtRandomPosition()

        
    }
    
    func addSprite() {
        
    }

    var left = false
    var right = true
    var up = false
    var down = false
    
    
    var manIsMoving:Bool = false
    
    func updateManPosition(theEvent: String)
    {
        if theEvent == "left"
        {

            left = true
            right = false
            up = false
            down = false
            
        }
        else if theEvent == "right"
        {
   
            left = false
            right = true
            up = false
            down = false
        }
        else if theEvent == "up"
        {
      
            left = false
            right = false
            up = true
            down = false
        }
        else if theEvent == "down" {
  
            left = false
            right = false
            up = false
            down = true
        }
        
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    
    
    func spawnAtRandomPosition() {
        
        let spriteX = sprite.position.x
        let spriteY = sprite.position.y
        
        
        var randomPosition = CGPointMake(CGFloat(randRange(90, upper: width - 100)), CGFloat(randRange(150, upper: height - 100)))
        
        
        while abs(randomPosition.x - spriteX) < 25 ||   abs(randomPosition.y - spriteY) < 25{
            randomPosition = CGPointMake(CGFloat(randRange(90, upper: width - 100)), CGFloat(randRange(150, upper: height - 100)))
        }
        
        let enemy = SKSpriteNode(imageNamed: "Enemy")
        enemy.size = CGSize(width: 50, height: 50)
        self.addChild(enemy)
        enemy.position = randomPosition
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size) // 1
        enemy.physicsBody?.dynamic = true // 2
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        print("Spawn")
        print(randomPosition)
        print(spriteX)
        print(spriteY)
    }
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, bad:SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        bad.removeFromParent()
        delay(0.2) {
            self.spawnAtRandomPosition()
        }
        
        score += 1
       
        if speedMode == true {
            speed += CGFloat(score) * (1/20)
        }

 
        myLabel.text = "Score: \(score)"
    }
    
    func shipDidCollideWithMonster(ship:SKSpriteNode, bad:SKSpriteNode) {
        print("Crash")
        bad.removeFromParent()
        ship.removeFromParent()
        
        delay(0.4) {
            self.spawnAtRandomPosition()
        }
        sprite.position.x = screenWidth/2
        sprite.position.y = screenHeight/2
        
        delay(0.4) {
            self.addChild(sprite)
            self.right = true
         
        }
        score = 0
        speed = 3
        myLabel.text = "Score: \(score)"
        
    }
    func didBeginContact(contact: SKPhysicsContact) {
        
        // 1
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask == 2 && PhysicsCategory.Projectile != 0)){
            projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, bad: secondBody.node as! SKSpriteNode)
        }
        
         if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ship != 0)) && secondBody.categoryBitMask == 0b100 {
            shipDidCollideWithMonster(firstBody.node as! SKSpriteNode, bad: secondBody.node as! SKSpriteNode)
        }
        
        
    }
    
    func didStartConact(contact: SKPhysicsContact) {
        
    }
    func updateScore(score: SKLabelNode) {
        score.removeFromParent()
        self.addChild(myLabel)
        
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func fireMissile(direciton:String) {
        let bullet = SKSpriteNode(imageNamed:"Laser")
        
        bullet.color = NSColor.greenColor()
        bullet.size = CGSize(width: 30,height: 10)
       
        bullet.position = CGPointMake(sprite.position.x, sprite.position.y)
        self.addChild(bullet)
        var vector = CGVectorMake(0, 0)
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.affectedByGravity = false
        
        // Determine vector to targetSprite
        if direction == "left" {
            vector = CGVectorMake(-150, 0)
            bullet.position = CGPointMake(sprite.position.x - 50, sprite.position.y)
            
        }
        else if direction == "right" {
            vector = CGVectorMake(150, 0)
              bullet.position = CGPointMake(sprite.position.x + 50, sprite.position.y)
        }
        else if direction == "up" {
            bullet.size = CGSize(width: 10,height: 30)
            vector = CGVectorMake(0, 150)
              bullet.position = CGPointMake(sprite.position.x, sprite.position.y + 50)
        }
        else if direction == "down" {
             bullet.size = CGSize(width: 10,height: 30)
            vector = CGVectorMake(0, -150)
              bullet.position = CGPointMake(sprite.position.x , sprite.position.y - 50)
        }
        
        
        // Create the action to move the bullet. Don't forget to remove the bullet!
        let bulletAction =
            SKAction.sequence([SKAction.repeatAction(SKAction.moveBy(vector, duration: 1), count: 10) ,  SKAction.waitForDuration(30.0/60.0), SKAction.removeFromParent()])
        bullet.runAction(bulletAction)
    }
    
    var fire = 0
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    
    override func keyDown(theEvent: NSEvent) // A key is pressed
    {
        if theEvent.keyCode == 123
        {
            direction = "left" //get the pressed key
            let rotate = SKAction.rotateToAngle(CGFloat(M_PI/2), duration: 0)
            sprite.runAction(rotate)
        }
            
        else if theEvent.keyCode == 124
        {
            direction = "right"
            let rotate = SKAction.rotateToAngle(CGFloat(3*M_PI/2) , duration: 0)
            sprite.runAction(rotate)

        }
        else if theEvent.keyCode == 126
        {
            direction = "up"
            let rotate = SKAction.rotateToAngle(CGFloat(2*M_PI) , duration: 0)
            sprite.runAction(rotate)
        }
        else if theEvent.keyCode == 125 {
            direction = "down"
            let rotate = SKAction.rotateToAngle(CGFloat(M_PI) , duration: 0)
            sprite.runAction(rotate)
        }
        
        else if theEvent.keyCode == 49 {
            fireMissile(direction)
            
        }
        
        
        manIsMoving = true //setting the boolean to true
    }
    
    override func keyUp(theEvent: NSEvent)
    {
        manIsMoving = false
    }
    
    override func mouseDown(theEvent: NSEvent) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        
        
        updateScore(myLabel)
        
        if manIsMoving
        {
            updateManPosition(direction)
        }
        
        if right == true {
            sprite.position.x += speed
            let rotate = SKAction.rotateToAngle(CGFloat(3*M_PI/2) , duration: 0)
            sprite.runAction(rotate)
        }
        else if left == true {
            sprite.position.x -= speed
            let rotate = SKAction.rotateToAngle(CGFloat(M_PI/2), duration: 0)
            sprite.runAction(rotate)
        }
        else if up == true {
            sprite.position.y += speed
            let rotate = SKAction.rotateToAngle(CGFloat(2*M_PI) , duration: 0)
            sprite.runAction(rotate)
        }
        else if down == true {
            sprite.position.y -= speed
            let rotate = SKAction.rotateToAngle(CGFloat(M_PI) , duration: 0)
            sprite.runAction(rotate)
        }
        if sprite.position.x < -60 {
            sprite.position.x = self.size.width
        }
        if sprite.position.x > self.size.width + 60 {
            sprite.position.x = 0
        }
        if sprite.position.y > self.size.height - 10 {
            sprite.position.y = 0
        }
        if sprite.position.y < 0 {
            sprite.position.y = self.size.height - 100
        }
    }
    
}
