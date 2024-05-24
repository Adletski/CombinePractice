//
//  Lesson9Practice.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 24.05.2024.
//

import SwiftUI
import Combine

struct Lesson9Practice: View {
    @StateObject var viewModel = Lesson9PracticeViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            
            HStack(spacing: 30) {
                Button("Добавить фрукт") {
                    viewModel.addProducts()
                }
                
                Button("Удалить фрукт") {
                    viewModel.deleteLastProduct()
                }
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

class Lesson9PracticeViewModel: ObservableObject {
    @Published var dataToView: [String] = []
    
    var data = ["Яблоко (начальный)", "Банан (начальный)", "Апельсин (начальный)", "Фрукт 4", "Фрукт 5", "Фрукт 6"]
    
    func fetch() {
        _ = Just("Яблоко (начальный)")
            .map { item in
                dataToView.append(item)
            }
    }
    
    func addProducts() {
        let random = data.randomElement()
        _ = random.publisher.sink { completion in
            print(completion)
        } receiveValue: { [unowned self] value in
            dataToView.append(value)
        }
    }
    
    func deleteLastProduct() {
        dataToView.removeLast()
    }
}

#Preview {
    Lesson9Practice()
}
