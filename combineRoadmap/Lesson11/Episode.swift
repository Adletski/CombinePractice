//
//  Episode.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 27.05.2024.
//

import Foundation

struct Episode {
    /// Идентификатор
    let id: Int
    /// Полный номер серии
    let serialNumerTitle: String
    /// Номер серии
    var serialNumber: Int
    /// Урл актера
    var characterURL: URL?
    /// Имя актера
    var characterName: String?
    /// Урл изображения актера
    var characterImage: URL?
    
    init(episodeDTO: EpisodeDTO) {
        self.id = episodeDTO.id
        serialNumerTitle = episodeDTO.episode
        self.serialNumber = Int(episodeDTO.episode.components(separatedBy: "E")[1]) ?? 0
        if let characterURL = episodeDTO.characters.randomElement() {
            self.characterURL = characterURL
        }
    }
}

struct CharacterDTO: Codable, Hashable {
    /// Имя
    let name: String
    /// Урл картинки
    let image: URL
}

struct EpisodeDTO: Codable, Hashable {
    /// Идентификатор
    var id: Int
    /// Эпизод
    let episode: String
    /// Актеры
    let characters: [URL]
}

