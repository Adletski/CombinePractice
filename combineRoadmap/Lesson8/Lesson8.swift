//
//  Lesson8.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 24.05.2024.
//

import SwiftUI
import Combine

struct Lesson8: View {
    @StateObject var viewModel = Lesson8ViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text(viewModel.firstResult)
            
            Button("start") {
                viewModel.runAgain()
            }
            
            Text(viewModel.secondResult)
        }
        .font(.title)
        .onAppear {
            viewModel.fetch()
        }
    }
}

class Lesson8ViewModel: ObservableObject {
    @Published var firstResult = ""
    @Published var secondResult = ""
    
    let futurePublisher = Deferred {
        Future<String, Never> { promise in
            promise(.success("FuturePublisher сработал."))
            print("FuturePublisher сработал.")
        }
    }
    
    func fetch() {
//        futurePublisher
//            .assign(to: &$firstResult)
        guard let url = URL(string: "") else { return }
//        createFetch(url: url) { result in
//            switch result {
//            case .success(let success):
//                print(success)
//            case .failure(let failure):
//                print(failure)
//            }
//        }
        _ = createFetch(url: url)
            .sink { completion in
                print(completion)
            } receiveValue: { [unowned self] value in
                firstResult = value ?? ""
            }
    }
    
    func runAgain() {
        futurePublisher
            .assign(to: &$secondResult)
    }
    
    func createFetch(url: URL) -> AnyPublisher<String?, Error> {
        Future { promise in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                promise(.success(response?.url?.absoluteString ?? ""))
            }
            task.resume()
        }.eraseToAnyPublisher()
    }
}

#Preview {
    Lesson8()
}
