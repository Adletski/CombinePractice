//
//  Lesson4.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 22.05.2024.
//

import SwiftUI
import Combine

struct Lesson4: View {
    
    @StateObject var viewModel = Lesson4ViewModel()
    
    var body: some View {
        Group {
            HStack {
                TextField("Name", text: $viewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.firstNameValidation)
            }
            HStack {
                TextField("Lastname", text: $viewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.lastNameValidation)
            }
            
        }.padding()
        
        Button("Cancel all validations") {
            viewModel.cancelAllValidations()
        }
    }
}

class Lesson4ViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var firstNameValidation = ""
    
    @Published var lastName = ""
    @Published var lastNameValidation = ""
    
    var validationCancellables: Set<AnyCancellable> = []

    init() {
        $firstName
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancellables)
        
        $lastName
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                self.lastNameValidation = value
            }
            .store(in: &validationCancellables)
    }
    
    func cancelAllValidations() {
        firstNameValidation = ""
        lastNameValidation = ""
        validationCancellables.removeAll()
    }
}

#Preview {
    Lesson4()
}
