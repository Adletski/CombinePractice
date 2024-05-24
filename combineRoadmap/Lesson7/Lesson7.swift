//
//  Lesson7.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 22.05.2024.
//

import SwiftUI
import Combine

struct Lesson7: View {
    @StateObject var viewModel = Lesson7ViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.age)")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            TextField("Input age", text: $viewModel.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("save") {
                viewModel.save()
            }
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Ошибка"), message: Text(error.rawValue))
        }
    }
}

enum InvalidAgeError: String, Error, Identifiable {
    var id: String {
        rawValue
    }
    case lessZero = "Значения не может быть меньше нуля."
    case moreHundred = "Значения не может быть больше ста."
}

class Lesson7ViewModel: ObservableObject {
    @Published var text = ""
    @Published var age = 0
    @Published var error: InvalidAgeError?
    
    func save() {
        _ = validationPublisher(age: Int(text) ?? -1)
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    break
                }
            } receiveValue: { [unowned self] value in
                self.age = value
            }
    }
    
    func validationPublisher(age: Int) -> AnyPublisher<Int, InvalidAgeError> {
        if age < 0 {
            return Fail(error: InvalidAgeError.lessZero)
                .eraseToAnyPublisher()
        } else if age > 100 {
            return Fail(error: InvalidAgeError.moreHundred)
                .eraseToAnyPublisher()
        }
        return Just(age)
            .setFailureType(to: InvalidAgeError.self)
            .eraseToAnyPublisher()
    }
}

//#Preview {
//    Lesson7()
//}
