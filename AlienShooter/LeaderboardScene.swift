//
//  LeaderboardScene.swift
//  AlienShooter
//
//  Created by Arina on 09.08.2023.
//

import SpriteKit
import UIKit

class LeaderboardScene: SKScene {
    var playerScores: [PlayerScore] = [] // массив для хранения результатов игроков
    var currentPlayerScore: PlayerScore? // Результат текущего игрока
    var tableView: UITableView!

    override func didMove(to view: SKView) {
        // Настройка интерфейса сцены, создание UITableView и другие UI элементы
        // Загрузка результатов игроков и отображение текущего игрока
        playerScores = UserDefaultsManager.shared.getPlayerScores()
        loadPlayerScores()

        // Настройка и отображение UITableView
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()

        // Добавление UITableView на сцену
        view.addSubview(tableView)
    }
    

    // Функция для загрузки результатов игроков из UserDefaults
//    func loadPlayerScores() {
//        if let topScoresData = UserDefaults.standard.data(forKey: "TopScores"),
//           let topScores = try? JSONDecoder().decode([PlayerScore].self, from: topScoresData) {
//            playerScores = topScores.sorted { $0.score > $1.score }
//        }
//
//        // загрузить результаты текущего игрока из UserDefaults, если они там сохранены
//    }
    func loadPlayerScores() {
        playerScores = UserDefaultsManager.shared.getPlayerScores()
        print(playerScores)
    }
}

extension LeaderboardScene: UITableViewDataSource, UITableViewDelegate {
    // Реализация методов UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(playerScores.count)
        return playerScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let playerScore = playerScores[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(playerScore.playerName): \(playerScore.score)"
        return cell
    }
}
