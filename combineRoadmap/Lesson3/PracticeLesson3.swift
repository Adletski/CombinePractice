//
//  PracticeLesson3.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 21.05.2024.
//

import SwiftUI
import Combine

struct PracticeLesson3: View {
    @StateObject var viewModel = PracticeLesson3ViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(viewModel.data)
                .font(.title)
                .foregroundColor(.green)
            
            Text(viewModel.status)
                .font(.title)
                .foregroundColor(.blue)
            
            Spacer()
            
            Button("Вызвать такси") {
                viewModel.refresh()
            }
            .font(.title)
            
            Button("Отменить такси") {
                viewModel.cancel()
            }
            .font(.title)
            .foregroundColor(.red)
            
            Spacer()
        }
    }
}

class PracticeLesson3ViewModel: ObservableObject {
    @Published var data = ""
    @Published var status = ""
    
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = $data
            .map { value in
                self.status = "Ищем машину"
                return value
            }
            .delay(for: 3, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.data = "Водитель будет через 10 мин"
                self?.status = ""
            })
    }
    
    func refresh() {
        data = "Перезапрос данных"
    }
    
    func cancel() {
        status = "Операция отменена"
        cancellable?.cancel()
        cancellable = nil
    }
}

#Preview {
    PracticeLesson3()
}
