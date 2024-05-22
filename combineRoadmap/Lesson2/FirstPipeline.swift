//
//  FirstPipeline.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 21.05.2024.
//

import SwiftUI

struct FirstPipeline: View {
    
    @StateObject var viewModel = FirstPipelineViewModel()
    
    var body: some View {
        HStack {
            TextField("your name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text(viewModel.validation)
        }.padding()
    }
}

class FirstPipelineViewModel: ObservableObject {
    @Published var name = ""
    @Published var validation = ""
    
    init() {
        $name
            .map { $0.isEmpty ? "❌" : "✅" }
            .assign(to: &$validation)
    }
}

#Preview {
    FirstPipeline()
}
