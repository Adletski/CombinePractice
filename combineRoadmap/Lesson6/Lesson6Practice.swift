//
//  Lesson6Practice.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 22.05.2024.
//

import SwiftUI
import Combine

struct Lesson6Practice: View {
    @StateObject var viewModel = Lesson6PracticeViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            TextField("Введите строку", text: $viewModel.textInfo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Добавить") {
                    viewModel.add(text: viewModel.textInfo)
                    viewModel.fetch()
                }.disabled(viewModel.textInfo.isEmpty)
                Spacer()
                Button("Очистить список") {
                    viewModel.removeAll()
                }
            }
            
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            
            Spacer()
        }.padding(.all, 30)
            .onAppear {
                viewModel.fetch()
            }
    }
}

class Lesson6PracticeViewModel: ObservableObject {
    @Published var textInfo = ""
    @Published var dataToView: [String] = []
    
    var datas: [String?] = []
    
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
    
    func add(text: String) {
        datas.append(text)
        textInfo = ""
    }
    
    func removeAll() {
        datas.removeAll()
        dataToView.removeAll()
    }
}

#Preview {
    Lesson6Practice()
}
