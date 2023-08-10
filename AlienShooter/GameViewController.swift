//
//  GameViewController.swift
//  AlienShooter
//
//  Created by Arina on 28.07.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var playerScores: [PlayerScore] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = MainMenuScene(size: view.bounds.size)
                let skView = view as! SKView
                skView.showsFPS = true
                skView.showsNodeCount = true
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .aspectFill //.resizeFill
                skView.presentScene(scene)
        
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
