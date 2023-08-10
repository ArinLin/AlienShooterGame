//
//  UserDefaultsManager.swift
//  AlienShooter
//
//  Created by Arina on 08.08.2023.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let playersKey = "Players"
    private let activePlayerKey = "ActivePlayer"
    private let topScoresKey = "TopScores"
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Players
    
    func savePlayer(name: String, email: String) {
        var players = getUsers()
        let player = Player(name: name, email: email)
        players.append(player)
        saveUsers(players)
    }
    
    func getUsers() -> [Player] {
        if let data = defaults.data(forKey: playersKey) {
            return (try? PropertyListDecoder().decode([Player].self, from: data)) ?? []
        } else {
            return []
        }
    }
    
    private func saveUsers(_ users: [Player]) {
        let data = try? PropertyListEncoder().encode(users)
        defaults.set(data, forKey: playersKey)
    }
    
    // MARK: - Active Player
    
    var activePlayer: Player? {
        get {
            if let data = defaults.data(forKey: activePlayerKey) {
                return try? PropertyListDecoder().decode(Player.self, from: data)
            }
            return nil
        }
        set {
            let data = try? PropertyListEncoder().encode(newValue)
            defaults.set(data, forKey: activePlayerKey)
        }
    }
    
    // MARK: - Leaderboard
    
    func updateLeaderboard(playerScores: [PlayerScore]) {
        if let encodedScores = try? JSONEncoder().encode(playerScores) {
            defaults.set(encodedScores, forKey: topScoresKey)
        } else {
            print("Failed to encode player scores.")
        }
    }
    
    func getPlayerScores() -> [PlayerScore] {
        if let topScoresData = defaults.data(forKey: topScoresKey),
           let decodedScores = try? JSONDecoder().decode([PlayerScore].self, from: topScoresData) {
            return decodedScores
        }
        return []
    }
    
    func savePlayerScore(_ playerScore: PlayerScore) {
        var topScores = getPlayerScores()
        topScores.append(playerScore)
        topScores.sort { $0.score > $1.score }
        updateLeaderboard(playerScores: topScores)
    }
}



//

//struct PlayerScore: Codable {
//    let playerName: String
//    let score: Int
//}
//
//func updateLeaderboard(playerScores: [PlayerScore]) {
//    if let encodedScores = try? JSONEncoder().encode(playerScores) {
//        UserDefaults.standard.set(encodedScores, forKey: "TopScores")
//        UserDefaults.standard.synchronize()
//    } else {
//        print("Failed to encode player scores.")
//    }
//}
//
//func savePlayerScore(_ playerScore: PlayerScore) {
//    var topScores = [PlayerScore]()
//    if let topScoresData = UserDefaults.standard.data(forKey: "TopScores"),
//       let decodedScores = try? JSONDecoder().decode([PlayerScore].self, from: topScoresData) {
//        topScores = decodedScores
//    }
//
//    topScores.append(playerScore)
//    topScores.sort { $0.score > $1.score }
//    let encodedScores = try? JSONEncoder().encode(topScores)
//    UserDefaults.standard.set(encodedScores, forKey: "TopScores")
//}

//let bestScores = [
//    PlayerScore(playerName: "Player1", score: 100),
//    PlayerScore(playerName: "Player2", score: 90),
//    PlayerScore(playerName: "Player3", score: 80)
//]

