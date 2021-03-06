//
//  GameScene.swift
//  CatNap
//
//  Created by Ma Xueyuan on 2018/08/18.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol EventListenerNode {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Cat: UInt32 = 0b1 //1
    static let Block: UInt32 = 0b10 //2
    static let Bed: UInt32 = 0b100 //4
    static let Edge: UInt32 = 0b1000 //8
    static let Label: UInt32 = 0b10000 //16
    static let Spring: UInt32 = 0b100000 //32
    static let Hook: UInt32 = 0b1000000 //64
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var bedNode: BedNode!
    var catNode: CatNode!
    var hookBaseNode: HookBaseNode?
    var playable = true
    var currentLevel: Int = 0
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .aspectFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        //spritekit bug?
        self.isPaused = true
        self.isPaused = false
        
        //Calculate playable margin
        let maxAspectRatio: CGFloat = 16/9
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
        
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin * 2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsBody?.categoryBitMask = PhysicsCategory.Edge
        physicsWorld.contactDelegate = self
        
        enumerateChildNodes(withName: "//*") { (node, _) in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        }
        
        bedNode = (childNode(withName: "bed") as! BedNode)
        catNode = (childNode(withName: "//cat_body") as! CatNode)
        hookBaseNode = childNode(withName: "hookBase") as? HookBaseNode
        
        
        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
        
        //let rotationConstrait = SKConstraint.zRotation(SKRange(lowerLimit: -π/4, upperLimit: π/4))
        //catNode.parent?.constraints = [rotationConstrait]
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func didSimulatePhysics() {
        if playable && hookBaseNode?.isHooked != true {
            if abs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
                lose()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == PhysicsCategory.Label | PhysicsCategory.Edge {
            print("LABEL")
            let labelNode = (contact.bodyA.categoryBitMask == PhysicsCategory.Label ? contact.bodyA.node : contact.bodyB.node) as! MessageNode
            labelNode.didBounce()
        }
        
        if !playable {
            return
        }
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
            print("SUCCESS")
            win()
        } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
            print("FAIL")
            lose()
        } else if collision == PhysicsCategory.Cat | PhysicsCategory.Hook && hookBaseNode?.isHooked == false {
            hookBaseNode?.hookCat(catPhysicsBody: (catNode.parent?.physicsBody)!)
        }
    }
    
    func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    @objc func newGame() {
        view?.presentScene(GameScene.level(levelNum: currentLevel))
    }
    
    func lose() {
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("lose.mp3")
        inGameMessage(text: "Try again...")
        perform(#selector(newGame), with: nil, afterDelay: 5)
        catNode.wakeUp()
    }
    
    func win() {
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        inGameMessage(text: "Nice job!")
        perform(#selector(newGame), with: nil, afterDelay: 3)
        catNode.curlAt(scenePoint: bedNode.position)
    }
}
