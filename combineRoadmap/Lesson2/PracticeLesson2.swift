//
//  PracticeLesson2.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 21.05.2024.
//

import SwiftUI

struct PracticeLesson2: View {
    @StateObject var viewModel = PracticeLesson2ViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name")
            HStack {
                TextField("Your name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.nameValidation)
            }
            Text("Password")
            HStack {
                if viewModel.isShow {
                    TextField("Your password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    SecureField("Your password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Text(viewModel.passwordValidation)
            }
            Button(action: {
                viewModel.isShow.toggle()
            }, label: {
                Text("Show password")
            })
        }.padding()
    }
}

class PracticeLesson2ViewModel: ObservableObject {
    @Published var name = ""
    @Published var password = ""
    @Published var nameValidation = ""
    @Published var passwordValidation = ""
    @Published var isShow = false
    
    init() {
        $name.map { $0.isEmpty ? "❌" : "✅"}
            .assign(to: &$nameValidation)
        
        $password.map {
            if $0.count > 10 {
                return "✅"
            } else {
                return "❌"
            }
        }
            .assign(to: &$passwordValidation)
    }
}

#Preview {
    PracticeLesson2()
}
