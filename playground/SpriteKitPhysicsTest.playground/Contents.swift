//: Playground - noun: a place where people can play

import UIKit
import SpriteKit
import PlaygroundSupport

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 480, height: 320))
let scene = SKScene(size: CGSize(width: 480, height: 320))
scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)

sceneView.showsFPS = true
sceneView.showsPhysics = true
sceneView.presentScene(scene)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = sceneView

let square = SKSpriteNode(imageNamed: "square")
square.name = "shape"
square.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height * 0.5)
square.physicsBody = SKPhysicsBody(rectangleOf: square.frame.size)

let circle = SKSpriteNode(imageNamed: "circle")
circle.name = "circle"
circle.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width/2)
circle.physicsBody?.isDynamic = false

let triangle = SKSpriteNode(imageNamed: "triangle")
triangle.name = "triangle"
triangle.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height * 0.5)
let trianglePath = CGMutablePath()
trianglePath.move(to: CGPoint(x: -triangle.size.width/2, y: -triangle.size.height/2))
trianglePath.addLine(to: CGPoint(x: triangle.size.width/2, y: -triangle.size.height/2))
trianglePath.addLine(to: CGPoint(x: 0, y: triangle.size.height/2))
trianglePath.addLine(to: CGPoint(x: -triangle.size.width/2, y: -triangle.size.height/2))
triangle.physicsBody = SKPhysicsBody(polygonFrom: trianglePath)

let l = SKSpriteNode(imageNamed: "L")
l.name = "shape"
l.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.75)
l.physicsBody = SKPhysicsBody(texture: l.texture!, size: l.size)

scene.addChild(square)
scene.addChild(circle)
scene.addChild(triangle)
scene.addChild(l)

func spawnSand() {
    let sand = SKSpriteNode(imageNamed: "sand")
    sand.name = "sand"
    sand.position = CGPoint(x: random(min: 0, max: scene.size.width), y: scene.size.height - sand.size.height)
    sand.physicsBody = SKPhysicsBody(circleOfRadius: sand.size.width/2)
    sand.physicsBody?.restitution = 0.5
    sand.physicsBody?.density = 20
    scene.addChild(sand)
}

func shake() {
    scene.enumerateChildNodes(withName: "sand") { (node, _) in
        node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: random(min: 20, max: 40)))
    }
    
    scene.enumerateChildNodes(withName: "shape") { (node, _) in
        node.physicsBody?.applyImpulse(CGVector(dx: random(min: 20, max: 60), dy: random(min: 20, max: 60)))
    }
    
    delay(seconds: 3, completion: shake)
}

delay(seconds: 2.0) {
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    scene.run(
        SKAction.repeat(
            SKAction.sequence([SKAction.run(spawnSand), SKAction.wait(forDuration: 0.1)]
        ), count: 100)
    )
    delay(seconds: 12, completion: shake)
}

var blowingRight = true
var windForce = CGVector(dx: 50, dy: 0)

extension SKScene {
    func applyWindForce() {
        enumerateChildNodes(withName: "sand") { (node, _) in
            node.physicsBody?.applyForce(windForce)
        }
        enumerateChildNodes(withName: "shape") { (node, _) in
            node.physicsBody?.applyForce(windForce)
        }
    }
    
    func switchWindDirection() {
        blowingRight = !blowingRight
        windForce = CGVector(dx: blowingRight ? 50 : -50, dy: 0)
    }
}

Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (_) in
    scene.applyWindForce()
}

Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (_) in
    scene.switchWindDirection()
}

circle.run(
    SKAction.repeatForever(
        SKAction.sequence([
            SKAction.moveTo(x: scene.size.width * 0.75, duration: 1),
            SKAction.moveTo(x: scene.size.width * 0.25, duration: 2),
            SKAction.moveTo(x: scene.size.width * 0.5, duration: 1)
        ])
    )
)



