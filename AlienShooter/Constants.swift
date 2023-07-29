//
//  Constants.swift
//  AlienShooter
//
//  Created by Arina on 29.07.2023.
//

import Foundation
import UIKit

enum Resourses {
    enum spaceComponentsNames {
        static let spaceship = "spaceship"
        static let alien = "ufo"
        static let asteroid = "asteroid"
        static let yellowPlanet = "planet1"
        static let bluePlanet = "planet2"
        static let redPlanet = "planet2"
    }
    
//    enum spaceComponents {
//        static let spaceship = UIImage(named: "spaceship")?.resized(to: CGSize(width: 10, height: 10))
//        static let alien = UIImage(named: "ufo")
//        static let asteroid = UIImage(named: "asteroid")
//        static let yellowPlanet = UIImage(named: "planet1")
//        static let bluePlanet = UIImage(named: "planet2")
//        static let redPlanet = UIImage(named: "planet2")
//    }
//    enum Colors {
//        static let valid = UIColor(named: "valid")
//        static let invalid = UIColor(named: "invalid")
//    }
}

//MARK: - Change Image size using UIGraphicsImageRenderer
extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resizedImage
    }
}
