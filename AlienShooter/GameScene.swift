//
//  GameScene.swift
//  AlienShooter
//
//  Created by Arina on 28.07.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // MARK: - Variables
    var spaceBG: SKEmitterNode!
    var player: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        spaceBG = SKEmitterNode(fileNamed: "Sky")
        spaceBG.position = CGPoint(x: 0, y: 1000)
        spaceBG.advanceSimulationTime(3)
        self.addChild(spaceBG)
        spaceBG.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "spaceship")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
