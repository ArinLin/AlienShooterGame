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
            scoreLabel.text = "\(Resourses.Texts.scoreLabel) \(score)"
        }
    }
    var gameTimer: Timer!
    var enemies = [Resourses.spaceComponentsNames.alien, Resourses.spaceComponentsNames.asteroid]
    
    var savePlayerScoreCallback: ((PlayerScore) -> Void)?
    
    override func didMove(to view: SKView) {
        // Set the anchor point to the center of the scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Create normalized positions
        let spaceBGPosition = CGPoint(x: 0.0, y: 0.5)
        let playerPosition = CGPoint(x: 0.0, y: -0.4)
        let labelPosition = CGPoint(x: -0.25, y: 0.4)
        
        spaceBG = SKEmitterNode(fileNamed: "Sky")
        spaceBG.position =  CGPoint(x: size.width * spaceBGPosition.x, y: size.height * spaceBGPosition.y)
        spaceBG.advanceSimulationTime(3)
        self.addChild(spaceBG)
        spaceBG.zPosition = -1
        
        player = SKSpriteNode(imageNamed: Resourses.spaceComponentsNames.spaceship)
        player.position = CGPoint(x: size.width * playerPosition.x, y: size.height * playerPosition.y)
        player.setScale(0.15)
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
        enemy.setScale(0.13)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        
        enemy.name = "enemy" // Assign a name to the enemy node
        self.addChild(enemy)
        
        // Calculate the movement duration based on the enemy's starting position
        let deltaX = player.position.x - xStart
        let deltaY = player.position.y - yStart
        let distanceToMove = hypot(deltaX, deltaY)
        let movementSpeed = CGFloat(200.0) // value for the desired speed
        
        // Move the enemy towards the player with a constant speed
        let movementDuration = TimeInterval(distanceToMove / movementSpeed)
        let moveAction = SKAction.move(to: player.position, duration: movementDuration)
        // TODO: - Взрыв и исчезновение с экрана
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        
        enemy.run(sequenceAction)
    }
    
    // MARK: - Spaceship Movement
    func moveSpaceshipRight() {
        let moveAction = SKAction.moveBy(x: 50, y: 0, duration: 0.1)
        player.run(moveAction)
    }
    
    func moveSpaceshipLeft() {
        let moveAction = SKAction.moveBy(x: -50, y: 0, duration: 0.1)
        player.run(moveAction)
    }
    
    func fire() {
        let torpedo = SKSpriteNode(imageNamed: Resourses.spaceComponentsNames.shoot)
        torpedo.setScale(0.06)
        torpedo.position = player.position
        torpedo.position.y += 5
        
        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: torpedo.size.width / 2)
        torpedo.physicsBody?.isDynamic = true
        
        torpedo.physicsBody?.usesPreciseCollisionDetection = true
        
        torpedo.name = "torpedo"
        self.addChild(torpedo)
        
        let animDuration: TimeInterval = 0.3
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: player.position.x, y: 800), duration: animDuration))
        actions.append(SKAction.removeFromParent())
        torpedo.run(SKAction.sequence(actions))
        
        // Check for collision with enemies
        checkEnemyCollision(torpedo: torpedo)
    }
    
    private func checkEnemyCollision(torpedo: SKSpriteNode) {
        for node in self.children {
            if node.name == "enemy" && torpedo.intersects(node) {
                // Collision with an enemy occurred
                explodeEnemy(enemy: node)
                torpedo.removeFromParent()
                score += 1
                break
            }
        }
    }
    
    
    private func explodeEnemy(enemy: SKNode) {
        // Play the explosion animation at the enemy's position
        let explosion = SKEmitterNode(fileNamed: "Explosion.sks")
        explosion?.position = enemy.position
        explosion?.zPosition = 1
        self.addChild(explosion!)
        
        // Remove the enemy after a short delay to simulate the explosion
        let removeEnemyAction = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), removeEnemyAction]))
        
        // Remove the explosion particle after it finishes
        let removeExplosionAction = SKAction.removeFromParent()
        explosion?.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), removeExplosionAction]))
    }
    
    private func checkCollisions() {
        for enemy in self.children where enemy.name == "enemy" {
            if player.intersects(enemy) {
                // Collision with an enemy occurred
                explodeEnemy(enemy: player)
                explodeEnemy(enemy: enemy)
                player.removeFromParent()
                enemy.removeFromParent()
                gameOver() 
                return
            }
            
            for torpedo in self.children where torpedo.name == "torpedo" {
                if torpedo.intersects(enemy) {
                    // Collision between torpedo and enemy occurred
                    explodeEnemy(enemy: enemy)
                    torpedo.removeFromParent()
                    score += 1
                    return
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        // Get the touch location in the scene's coordinate system
        let touchLocation = touch.location(in: self)

        // Check if the touch location is to the left or right of the spaceship
        if touchLocation.x > player.position.x {
            moveSpaceshipRight()
        } else {
            moveSpaceshipLeft()
        }

        // Fire a torpedo when the screen is tapped
        fire()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        checkCollisions()
    }
    
    private func gameOver() {
        let playerScore = PlayerScore(playerName: UserDefaultsManager.shared.activePlayer?.name ?? "default", score: score)
        savePlayerScoreCallback?(playerScore)
        
            gameTimer.invalidate() // Stop the timer that spawns enemies
            removeAllActions() // Stop all actions on the scene

            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.scaleMode = .aspectFill
            self.view?.presentScene(gameOverScene)
    }
}
