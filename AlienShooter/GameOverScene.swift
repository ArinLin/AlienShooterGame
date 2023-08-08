//
//  GameOverScene.swift
//  AlienShooter
//
//  Created by Arina on 08.08.2023.
//

import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        createGameOverScreen()
    }

    func createGameOverScreen() {
        // Set the anchor point to the center of the scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // Create normalized positions
        let gameOverLabelPosition = CGPoint(x: 0.0, y: 0.1)
        let playAgainButtonPosition = CGPoint(x: 0.0, y: 0.0)
        let mainMenuButtonPosition = CGPoint(x: 0.0, y: -0.1)

        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "AmericanTypewriter-Bold"
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: size.width * gameOverLabelPosition.x, y: size.height * gameOverLabelPosition.y)
        addChild(gameOverLabel)

        let playAgainButton = createButton(text: "Play Again", position: CGPoint(x: size.width * playAgainButtonPosition.x, y: size.height * playAgainButtonPosition.y))
        let mainMenuButton = createButton(text: "Main Menu", position: CGPoint(x: size.width * mainMenuButtonPosition.x, y: size.height * mainMenuButtonPosition.y))

        addChild(playAgainButton)
        addChild(mainMenuButton)
    }

    func createButton(text: String, position: CGPoint) -> SKLabelNode {
        let button = SKLabelNode(text: text)
        button.fontName = "AmericanTypewriter-Bold"
        button.fontSize = 36
        button.fontColor = .white
        button.position = position
        button.name = text.lowercased()

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
        case "play again":
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.view?.presentScene(gameScene)

        case "main menu":
            let mainMenuScene = MainMenuScene(size: self.size)
            mainMenuScene.scaleMode = .aspectFill
            self.view?.presentScene(mainMenuScene)

        default:
            break
        }
    }
}
