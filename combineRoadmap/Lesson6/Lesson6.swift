//
//  Lesson6.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 22.05.2024.
//

import SwiftUI
import Combine

struct Lesson6: View {
    @StateObject var viewModel = Lesson6ViewModel()
    
    var isVisible = false
    
    var body: some View {
        VStack(spacing: 20) {
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            .font(.title)
            Button("add") {
                viewModel.add()
            }
        }.onAppear {
            viewModel.fetch()
        }
    }
}

class Lesson6ViewModel: ObservableObject {
    @Published var dataToView: [String] = []
    
    var datas = ["Value 1", "Value 2", "Value 3", "Value 4", nil, "Value 6"]
    
    func fetch() {
        _ = datas.publisher.flatMap { item -> AnyPublisher<String, Never> in
            if let item = item {
                return Just(item)
                    .eraseToAnyPublisher()
            } else {
                return Empty(completeImmediately: true)
                    .eraseToAnyPublisher()
            }
        }
        .sink { [unowned self] item in
            dataToView.append(item)
        }
    }
    
    func add() {
        datas.append("adlet")
    }
}

#Preview {
    Lesson6()
}
