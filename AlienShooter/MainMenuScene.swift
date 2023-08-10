//
//  MainMenuScene.swift
//  AlienShooter
//
//  Created by Arina on 08.08.2023.
//

import SpriteKit

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        createMainMenu()
    }
    
    func createMainMenu() {
        // Set the anchor point to the center of the scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Create normalized positions
        let startButtonPosition = CGPoint(x: 0.0, y: 0.1)
        let leaderboardButtonPosition = CGPoint(x: 0.0, y: 0.0)
        let settingsButtonPosition = CGPoint(x: 0.0, y: -0.1)
        
        let startButton = createButton(text: "Start", position: CGPoint(x: size.width * startButtonPosition.x, y: size.height * startButtonPosition.y))
        let leaderboardButton = createButton(text: "Leaderboard", position: CGPoint(x: size.width * leaderboardButtonPosition.x, y: size.height * leaderboardButtonPosition.y))
        let settingsButton = createButton(text: "Settings", position: CGPoint(x: size.width * settingsButtonPosition.x, y: size.height * settingsButtonPosition.y))
        
        addChild(startButton)
        addChild(leaderboardButton)
        addChild(settingsButton)
    }
    
    func createButton(text: String, position: CGPoint) -> SKLabelNode {
        let button = SKLabelNode(text: text)
        button.fontName = "AmericanTypewriter-Bold"
        button.fontSize = 36
        button.fontColor = .white
        button.position = position
        button.name = text.lowercased() // Set the button name to its lowercase text
        
        return button
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if let node = self.nodes(at: touchLocation).first as? SKLabelNode {
            handleButtonTap(buttonName: node.name)
        }
    }
    
    func handleButtonTap(buttonName: String?) {
        guard let name = buttonName else { return }
        
        switch name {
        case "start":
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            gameScene.savePlayerScoreCallback = { [weak self] playerScore in
                self?.savePlayerScore(playerScore)
            }
            self.view?.presentScene(gameScene)
            
        case "leaderboard":
            let leaderboardScene = LeaderboardScene(size: self.size)
            leaderboardScene.scaleMode = .aspectFill
            leaderboardScene.playerScores = UserDefaultsManager.shared.getPlayerScores()
            self.view?.presentScene(leaderboardScene)
//            let leaderboardScene = LeaderboardScene(size: self.size)
//                       leaderboardScene.scaleMode = .aspectFill
//                       self.view?.presentScene(leaderboardScene)
        case "settings":
            let settingsScene = SettingsScene(size: self.size)
            settingsScene.scaleMode = .aspectFill
            self.view?.presentScene(settingsScene)
            
        default:
            break
        }
    }
    func savePlayerScore(_ playerScore: PlayerScore) {
            UserDefaultsManager.shared.savePlayerScore(playerScore)
        }
}
