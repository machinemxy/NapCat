//
//  BedNode.swift
//  CatNap
//
//  Created by Ma Xueyuan on 2018/08/22.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import SpriteKit

class BedNode: SKSpriteNode, EventListenerNode {
    func didMoveToScene() {
        print("bed added to scene")
        let bedBodySize = CGSize(width: 40, height: 30)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.Bed
        physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}
