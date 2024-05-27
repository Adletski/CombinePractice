//
//  Lesson11.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 27.05.2024.
//

import SwiftUI
import Combine

/// "https://jsonplaceholder.typicode.com/posts"
/// "https://via.placeholder.com/600/d32776"

struct Lesson11: View {
    @StateObject var viewModel = Lesson11ViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            List(viewModel.dataToView, id: \.title) { post in
                Text(post.title)
                    .font(.title)
                    .bold()
                Text(post.body)
                    .font(.caption2)
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

struct Post: Decodable {
    let title: String
    let body: String
}

struct ErrorForAlert: Error, Identifiable {
    let id = UUID()
    let title = "Error"
    let message = "try again later"
}

class Lesson11ViewModel: ObservableObject {
    @Published var dataToView: [Post] = []
    @Published var image: Image?
    @Published var alertError: ErrorForAlert?
    
    var cancellable: Set<AnyCancellable> = []
    
    func fetch() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [unowned self] posts in
                dataToView = posts
            }
            .store(in: &cancellable)
    }
}

#Preview {
    Lesson11()
}
