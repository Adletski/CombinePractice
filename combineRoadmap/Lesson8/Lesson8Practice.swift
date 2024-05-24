//
//  Lesson8Practice.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 24.05.2024.
//

import SwiftUI
import Combine

struct Lesson8Practice: View {
    @StateObject var viewModel = Lesson8PracticeViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            TextField("Input", text: $viewModel.textInfo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Проверить простоту числа.") {
                
            }
            
            Text("6 - не простое число")
                .foregroundColor(.green)
        }.padding()
    }
}

enum NumberError: Error {
    case notPure
}

class Lesson8PracticeViewModel: ObservableObject {
    @Published var textInfo = ""
    
    func fetch() {
        _ = createFetch(text: textInfo)
    }
    
    func createFetch(text: String) -> AnyPublisher<String, NumberError> {
        Future { promise in
            if let number = Int(text) {
                if (number % 2 == 0) && (number % 1 == 0) {
                    promise(.failure(.notPure))
                } else {
                    promise(.success(String(number)))
                }
            }
        }.eraseToAnyPublisher()
    }
}

#Preview {
    Lesson8Practice()
}
