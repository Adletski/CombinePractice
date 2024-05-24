//
//  SwiftUIView.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 24.05.2024.
//

import SwiftUI
import Combine

struct Lesson9: View {
    @StateObject var viewModel = Lesson9ViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.title)
                .bold()
            
            Form {
                Section(header: Text("Участники конкурса").padding()) {
                    List(viewModel.dataToView, id: \.self) { item in
                        Text(item)
                    }
                }
            }
        }
            .onAppear {
                viewModel.fetch()
            }
    }
}

class Lesson9ViewModel: ObservableObject {
    @Published var title = ""
    @Published var dataToView: [String] = []
    
    var names = ["Julian", "Jack", "Marina"]
    
    func fetch() {
        _ = names.publisher
            .sink { completion in
                print(completion)
            } receiveValue: { [unowned self] value in
                dataToView.append(value)
                print(value)
            }
        
        if names.count > 0 {
            Just("adlet")
                .map { item in
                    item.uppercased()
                }
                .assign(to: &$title)
        }
    }
}

#Preview {
    Lesson9()
}
