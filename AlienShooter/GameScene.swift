//
//  GameScene.swift
//  AlienShooter
//
//  Created by Arina on 28.07.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Variables
    var spaceBG: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Счет: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        // Set the anchor point to the center of the scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Create normalized positions
        let spaceBGPosition = CGPoint(x: 0.0, y: 0.5)
        let playerPosition = CGPoint(x: 0.0, y: -0.4)
        let labelPosition = CGPoint(x: -0.3, y: 0.4)
        
        spaceBG = SKEmitterNode(fileNamed: "Sky")
        spaceBG.position =  CGPoint(x: size.width * spaceBGPosition.x, y: size.height * spaceBGPosition.y) //CGPoint(x: 0, y: 1000)
        spaceBG.advanceSimulationTime(3)
        self.addChild(spaceBG)
        spaceBG.zPosition = -1
        
        player = SKSpriteNode(imageNamed: Resourses.spaceComponentsNames.spaceship)
        player.position = CGPoint(x: size.width * playerPosition.x, y: size.height * playerPosition.y) //CGPoint(x: 0, y: -500)
        player.setScale(0.18)
        self.addChild(player)
        
        scoreLabel = SKLabelNode(text: "Счет: 0")
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: size.width * labelPosition.x, y: size.height * labelPosition.y)
        score = 0
        self.addChild(scoreLabel)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
