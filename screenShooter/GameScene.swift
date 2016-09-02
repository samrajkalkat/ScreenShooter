//
//  GameScene.swift
//  screenShooter
//
//  Created by samraj on 8/31/16.
//  Copyright (c) 2016 Samraj. All rights reserved.
//

import SpriteKit
var direction = ""
let sprite = SKSpriteNode(imageNamed:"Ship")


class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Helvetica")
////        myLabel.text = "Hello"
////        myLabel.fontSize = 45
////        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))

        self.view?.allowsTransparency = true
        self.backgroundColor = NSColor.clearColor()
        sprite.size = CGSize(width: 40, height: 60)
        self.addChild(sprite)
        sprite.position.x = self.size.width/2
        sprite.position.y = self.size.height/2
        
        let action = SKAction.rotateByAngle(CGFloat(3*M_PI/2) , duration: 0)
        sprite.runAction(action)

        self.view?.window?.titleVisibility = NSWindowTitleVisibility.Hidden
        self.view?.window?.titlebarAppearsTransparent = true
    
        spawnAtRandomPosition()
        
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
    
    func spawnAtRandomPosition() {
        let height = UInt32(self.view!.frame.height) - 20
        let width = UInt32(self.view!.frame.width) - 20
        
        let randomPosition = CGPointMake(CGFloat(arc4random_uniform(width) + 20), CGFloat(arc4random_uniform(height - 20) + 20))
        
        let enemy = SKSpriteNode(imageNamed: "Enemy")
        enemy.size = CGSize(width: 20, height: 20)
        
        self.addChild(enemy)
        enemy.position = randomPosition
    }
    
    func fireMissile(direciton:String) {
        let bullet = SKSpriteNode(imageNamed:"Laser")
        bullet.color = NSColor.greenColor()
        bullet.size = CGSize(width: 10,height: 10)
        bullet.position = CGPointMake(sprite.position.x, sprite.position.y)
        self.addChild(bullet)
        var vector = CGVectorMake(0, 0)
        
        // Determine vector to targetSprite
        if direction == "left" {
            vector = CGVectorMake(-750, 0)
        }
        else if direction == "right" {
            vector = CGVectorMake(750, 0)
        }
        else if direction == "up" {
            vector = CGVectorMake(0, 750)
        }
        else if direction == "down" {
            vector = CGVectorMake(0, -750)
        }
        
        
        // Create the action to move the bullet. Don't forget to remove the bullet!
        let bulletAction = SKAction.sequence([SKAction.repeatAction(SKAction.moveBy(vector, duration: 1), count: 10) ,  SKAction.waitForDuration(30.0/60.0), SKAction.removeFromParent()])
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
        if manIsMoving
        {
            updateManPosition(direction)
        }
        
        if right == true {
            sprite.position.x += 5
        }
        else if left == true {
            sprite.position.x -= 5
        }
        else if up == true {
            sprite.position.y += 5
        }
        else if down == true {
            sprite.position.y -= 5
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
            sprite.position.y = self.size.height
        }
    }
    
}
