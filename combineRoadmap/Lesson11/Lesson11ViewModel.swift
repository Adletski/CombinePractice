//
//  Lesson11ViewModel.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 27.05.2024.
//

import SwiftUI
import Combine

final class URLSessionDataTaskPublisherViewModel: ObservableObject {
    private enum Constants {
        static let apiUrl = "https://rickandmortyapi.com/api/episode/1,2,3,4,5,6,7,8,9,10,11"
    }
    
    @Published var state: ViewState<[Episode]> = .loading
    
    var cancellables: Set<AnyCancellable> = []
    var episodes: [Episode] = []
    
    func fetch() {
        guard let url = URL(string: Constants.apiUrl) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [EpisodeDTO].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    state = .error(error)
                }
            } receiveValue: { [unowned self] posts in
                posts
                    .publisher
                    .sink { [unowned self] completion in
                        if case .failure(let error) = completion {
                            state = .error(error)
                        }
                    } receiveValue: { [unowned self] episode in
                        fetchEpisode(episode)
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
    }
    
    func fetchEpisode(_ episodeDTO: EpisodeDTO) {
        var episode = Episode(episodeDTO: episodeDTO)
        
        guard let characterURL = episode.characterURL else { return }

        URLSession.shared.dataTaskPublisher(for: characterURL)
            .map { $0.data }
            .decode(type: CharacterDTO.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    state = .error(error)
                }
            } receiveValue: { [unowned self] character in
                episode.characterImage = character.image
                episode.characterName = character.name
                episodes.append(episode)
                episodes.sort { $0.serialNumber < $1.serialNumber }
                state = .data(episodes)
            }
            .store(in: &cancellables)
    }
}
