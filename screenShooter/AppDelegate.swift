//
//  AppDelegate.swift
//  screenShooter
//
//  Created by samraj on 8/31/16.
//  Copyright (c) 2016 Samraj. All rights reserved.
//


import Cocoa
import SpriteKit

var speedMode = false
var multiMode = false
var normalMode = true

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    var speedModeSelected = false
    var multiModeSelected = false
    
    @IBAction func normalModePressed(sender: AnyObject) {
        speedMode = false
        multiMode = false
    }
    @IBAction func multiModeSelected(sender: AnyObject) {
        if multiModeSelected == false {
            speedMode = false
            multiMode = true
            multiModeSelected = true
        }
        else {
            multiMode = false
            normalMode = true
            speedMode = false
        }
        
    }
    
    @IBAction func speedModePressed(sender: AnyObject) {
        if speedModeSelected == false {
            speedMode = true
            speedModeSelected = true
            normalMode = true
            multiMode = false
        }
        else {
            speedMode = false
            normalMode = true
            multiMode = false
        }
        
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            window.opaque = false
            
            window.backgroundColor = NSColor.clearColor()
            self.skView!.presentScene(scene)
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
//            
//            self.skView!.showsFPS = true
//            self.skView!.showsNodeCount = true
            
            if let screen = NSScreen.mainScreen() {
                window.setFrame(screen.visibleFrame, display: true, animate: true)
            }
            
      
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
