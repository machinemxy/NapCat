//
//  MessageNode.swift
//  CatNap
//
//  Created by Ma Xueyuan on 2018/08/26.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import SpriteKit

class MessageNode: SKLabelNode {
    var bounceTimes = 0
    
    convenience init(message: String) {
        self.init(fontNamed: "AvenirNext-Regular")
        text = message
        fontSize = 256
        fontColor = SKColor.gray
        zPosition = 100
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256
        front.fontColor = SKColor.white
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody?.categoryBitMask = PhysicsCategory.Label
        physicsBody?.collisionBitMask = PhysicsCategory.Edge
        physicsBody?.contactTestBitMask = PhysicsCategory.Edge
        physicsBody?.restitution = 0.7
    }
    
    func didBounce() {
        bounceTimes += 1
        print("bounced: \(bounceTimes)")
        if bounceTimes >= 3 {
            removeFromParent()
        }
    }
}
