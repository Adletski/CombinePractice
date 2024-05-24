//
//  Lesson7Practice.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 22.05.2024.
//

import SwiftUI
import Combine

struct Lesson7Practice: View {
    @StateObject var viewModel = Lesson7PracticeViewModel()
    
    var body: some View {
        VStack(spacing: 50) {
            TextField("Input something", text: $viewModel.textInfo)
            
            HStack(spacing: 50) {
                Button("Добавить") {
                    viewModel.save()
                }
    
                Button("Очистить список") {
                    viewModel.removeAll()
                }
            }
            
            Text(viewModel.error).foregroundColor(.red)
            
            List(viewModel.dataToView, id: \.self) { item in
                Text(item)
            }
            
            Spacer()
        }.padding()
    }
}

enum InvalidIntError: String, Error {
    case notNumber
    
    var description: String {
        switch self {
        case .notNumber:
            return "Введенное значение не является числом."
        }
    }
}

class Lesson7PracticeViewModel: ObservableObject {
    @Published var textInfo = ""
    @Published var error = ""
    @Published var dataToView: [String] = ["1","2","3"]
    
    func save() {
        _ = validationPublisher(text: textInfo)
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    self.error = error.description
                case .finished:
                    break
                }
            } receiveValue: { [unowned self] value in
                self.dataToView.append(value)
            }
    }
    
    func validationPublisher(text: String) -> AnyPublisher<String, InvalidIntError> {
        if let number = Int(text) {
            return Just(String(number))
                .setFailureType(to: InvalidIntError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: InvalidIntError.notNumber)
                .eraseToAnyPublisher()
        }
    }
    
    func removeAll() {
        dataToView.removeAll()
        textInfo = ""
        error = ""
    }
}

#Preview {
    Lesson7Practice()
}
