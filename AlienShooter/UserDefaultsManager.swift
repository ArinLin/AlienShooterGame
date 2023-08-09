//
//  UserDefaultsManager.swift
//  AlienShooter
//
//  Created by Arina on 08.08.2023.
//

import Foundation

struct PlayerScore: Codable {
    let playerName: String
    let score: Int
}

func updateLeaderboard(playerScores: [PlayerScore]) {
    if let encodedScores = try? JSONEncoder().encode(playerScores) {
        UserDefaults.standard.set(encodedScores, forKey: "TopScores")
        UserDefaults.standard.synchronize()
    } else {
        print("Failed to encode player scores.")
    }
}

func savePlayerScore(_ playerScore: PlayerScore) {
    var topScores = [PlayerScore]()
    if let topScoresData = UserDefaults.standard.data(forKey: "TopScores"),
       let decodedScores = try? JSONDecoder().decode([PlayerScore].self, from: topScoresData) {
        topScores = decodedScores
    }
    
    topScores.append(playerScore)
    topScores.sort { $0.score > $1.score }
    let encodedScores = try? JSONEncoder().encode(topScores)
    UserDefaults.standard.set(encodedScores, forKey: "TopScores")
}

//let bestScores = [
//    PlayerScore(playerName: "Player1", score: 100),
//    PlayerScore(playerName: "Player2", score: 90),
//    PlayerScore(playerName: "Player3", score: 80)
//]

