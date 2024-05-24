//
//  Lesson5.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 22.05.2024.
//

import SwiftUI
import Combine

struct Lesson5: View {
    @StateObject var viewModel = Lesson5ViewModel()
    
    var body: some View  {
        VStack {
            Text("\(viewModel.selectionSame.value ? "Два раза выбрали значение" : "") \(viewModel.selection.value)")
                .foregroundColor(viewModel.selectionSame.value ? .red : .green)
                .padding()
            
            Button("Выбрать колу") {
                viewModel.selection.value = "Кола"
            }.padding()
            
            Button("Выбрать бургер") {
                viewModel.selection.value = "Бургер"
            }.padding()
        }
    }
}

class Lesson5ViewModel: ObservableObject {
    var selection = CurrentValueSubject<String, Never>("Корзина пуста")
    var selectionSame = CurrentValueSubject<Bool, Never>(false)
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        selection
            .map { [unowned self] newValue -> Bool in
                if newValue == selection.value {
                    return true
                } else {
                    return false
                }
            }
            .sink { [unowned self] value in
                self.selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellable)
    }
}

#Preview {
    Lesson5()
}
