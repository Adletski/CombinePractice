//
//  SecondPipeline.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 21.05.2024.
//

import SwiftUI
import Combine

struct FirstCancellablePipeline: View {
    
    @StateObject var viewModel = FirstCancellablePipelineViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.data)
                .font(.title)
                .foregroundColor(.green)
            
            Text(viewModel.status)
                .foregroundColor(.blue)
        }
    }
}

class FirstCancellablePipelineViewModel: ObservableObject {
    @Published var data = ""
    @Published var status = ""
    
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = $data
            .map { [unowned self] value in
//                self.status = "Запрос в банк..."
                return "Запрос в банк..."
            }
            .sink { [unowned self] value in
                self.data = "Сумма всех счетов 1 млн"
                self.status = "Данные получены"
            }
    }
}

#Preview {
    FirstCancellablePipeline()
}
