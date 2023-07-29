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
    var gameTimer: Timer!
    var enemies = [Resourses.spaceComponentsNames.alien, Resourses.spaceComponentsNames.asteroid]
    
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
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, // при увеличении влияет на скорость игры
                                         target: self,
                                         selector: #selector(appearUfo),
                                         userInfo: nil,
                                         repeats: true)
    }
    // MARK: - Private?
    @objc private func appearUfo() {
        guard let enemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemies) as? [String] else { return }
        let enemy = SKSpriteNode(imageNamed: enemies[0])
        
        // Set initial position outside the screen boundaries
                let xStart = CGFloat.random(in: -self.size.width ... self.size.width)
                let yStart = self.size.height * 1.1 // Slightly above the top of the screen

        enemy.position = CGPoint(x: xStart, y: yStart)
                enemy.setScale(0.15)
                enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                enemy.physicsBody?.isDynamic = true
        
//        let randomXPosition = CGFloat.random(in: -self.size.width * 0.3 ... self.size.width * 0.3)
//
//        enemy.position = CGPoint(x: randomXPosition, y: self.size.height * 0.5)
//        enemy.setScale(0.15)
//        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
//        enemy.physicsBody?.isDynamic = true
        
        enemy.name = "enemy" // Assign a name to the enemy node
        self.addChild(enemy)
        
        // Calculate the movement duration based on the enemy's starting position
                let deltaX = player.position.x - xStart
                let deltaY = player.position.y - yStart
                let distanceToMove = hypot(deltaX, deltaY)
                let movementSpeed = CGFloat(200.0) // Adjust this value for the desired speed

                // Move the enemy towards the player with a constant speed
                let movementDuration = TimeInterval(distanceToMove / movementSpeed)
                let moveAction = SKAction.move(to: player.position, duration: movementDuration)
        // TODO: - Взрыв и исчезновение с экрана
                let removeAction = SKAction.removeFromParent()
                let sequenceAction = SKAction.sequence([moveAction, removeAction])

                enemy.run(sequenceAction)
        
//        // Calculate the movement duration based on the enemy's starting position
//        let distanceToMove = abs(randomXPosition) // value for the desired distance
//        let movementDuration = TimeInterval(distanceToMove / 10) // divisor for the desired speed
//
//        // Move the enemy towards the spaceship
//        let moveAction = SKAction.move(to: player.position, duration: movementDuration)
//        let removeAction = SKAction.removeFromParent()
//        let sequenceAction = SKAction.sequence([moveAction, removeAction])
//
//        enemy.run(sequenceAction)
    }
    
    func fire() {
        let torpedo = SKSpriteNode(imageNamed: Resourses.spaceComponentsNames.shoot)
        torpedo.setScale(0.1)
        torpedo.position = player.position
        torpedo.position.y += 5
        
        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: torpedo.size.width / 2)
        torpedo.physicsBody?.isDynamic = true
        
        torpedo.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedo)
        
        let animDuration: TimeInterval = 0.3
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: 800), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        torpedo.run(SKAction.sequence(actions))
    }
    
    // по тапу на экран стрелять
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fire()
    }
    
    private func checkCollisions() {
            // Loop through all nodes in the scene
            for node in self.children {
                if node.name == "enemy" {
                    // Check for collisions with the player node
                    if node.intersects(player) {
                        // Handle the collision (e.g., decrease player health, end the game, etc.)
                        node.removeFromParent()
                        score += 1
                    }
                }
            }
        }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        checkCollisions()
    }
}
