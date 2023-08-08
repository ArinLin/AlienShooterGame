//
//  SettingsScene.swift
//  AlienShooter
//
//  Created by Arina on 08.08.2023.
//

import SpriteKit

class SettingsScene: SKScene {
    // Add properties for text fields and difficulty control
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var difficultyControl: UISegmentedControl!
    
    override func didMove(to view: SKView) {
        createSettingsScreen()
    }

    func createSettingsScreen() {
        // Set the anchor point to the center of the scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Create normalized positions
        let nameLabelPosition = CGPoint(x: -0.3, y: 0.2)
        let emailLabelPosition = CGPoint(x: -0.3, y: 0.1)
        let difficultyLabelPosition = CGPoint(x: -0.3, y: 0.0)
        let saveButtonPosition = CGPoint(x: 0.0, y: -0.2)
        
        let nameLabel = SKLabelNode(text: "Name:")
        nameLabel.fontName = "AmericanTypewriter-Bold"
        nameLabel.fontSize = 20
        nameLabel.fontColor = .white
        nameLabel.position = CGPoint(x: size.width * nameLabelPosition.x, y: size.height * nameLabelPosition.y)
        addChild(nameLabel)
        
        let emailLabel = SKLabelNode(text: "Email:")
        emailLabel.fontName = "AmericanTypewriter-Bold"
        emailLabel.fontSize = 20
        emailLabel.fontColor = .white
        emailLabel.position = CGPoint(x: size.width * emailLabelPosition.x, y: size.height * emailLabelPosition.y)
        addChild(emailLabel)
        
        let difficultyLabel = SKLabelNode(text: "Difficulty:")
        difficultyLabel.fontName = "AmericanTypewriter-Bold"
        difficultyLabel.fontSize = 20
        difficultyLabel.fontColor = .white
        difficultyLabel.position = CGPoint(x: size.width * difficultyLabelPosition.x, y: size.height * difficultyLabelPosition.y)
        addChild(difficultyLabel)
        
        // Create text fields for name and email input
        nameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        nameTextField.placeholder = "Enter Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.autocapitalizationType = .words
        
        // Convert the nameTextField position from scene coordinates to view coordinates
        let nameTextFieldViewPosition = view!.convert(CGPoint(x: size.width * 0.2, y: size.height * 0.21), from: self)
        nameTextField.center = nameTextFieldViewPosition
        view?.addSubview(nameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        emailTextField.placeholder = "Enter Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        
        // Convert the emailTextField position from scene coordinates to view coordinates
        let emailTextFieldViewPosition = view!.convert(CGPoint(x: size.width * 0.2, y: size.height * 0.11), from: self)
        emailTextField.center = emailTextFieldViewPosition
        view?.addSubview(emailTextField)
        
        // Create a segmented control for difficulty selection
        let difficultyOptions = ["Easy", "Medium", "Hard"]
        difficultyControl = UISegmentedControl(items: difficultyOptions)
        difficultyControl.selectedSegmentIndex = 0 // Default to Easy
        
        let difficultyControlViewPosition = view!.convert(CGPoint(x: size.width * 0.2, y: size.height * 0.0), from: self)
        difficultyControl.frame = CGRect(x: difficultyControlViewPosition.x - 100, y: difficultyControlViewPosition.y - 20, width: 200, height: 30)
        
        view?.addSubview(difficultyControl)
        
        let saveButton = createButton(text: "Save", position: CGPoint(x: size.width * saveButtonPosition.x, y: size.height * saveButtonPosition.y))
        addChild(saveButton)
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
        case "save":
            // Save user settings
            let userName = nameTextField.text ?? ""
            let userEmail = emailTextField.text ?? ""
            let selectedDifficultyIndex = difficultyControl.selectedSegmentIndex
            let difficulty = ["Easy", "Medium", "Hard"][selectedDifficultyIndex]

            // something with the user settings, such as saving to UserDefaults or a backend server

            print("Name: \(userName), Email: \(userEmail), Difficulty: \(difficulty)")

        default:
            break
        }
    }
}
