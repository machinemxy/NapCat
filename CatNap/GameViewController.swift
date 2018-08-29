//
//  GameViewController.swift
//  CatNap
//
//  Created by Ma Xueyuan on 2018/08/18.
//  Copyright © 2018年 Ma Xueyuan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene.level(levelNum: 2) {
                
                // Present the scene
                view.presentScene(scene)
            }
            
            //nodes with same zPosition are drawn in the order in which they are added to the scene
            view.ignoresSiblingOrder = false
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
