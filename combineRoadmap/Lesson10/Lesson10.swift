//
//  Lesson10.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 24.05.2024.
//

import SwiftUI
import Combine

enum ViewState<Model> {
    case loading
    case data(_ data: Model)
    case error(_ error: Error)
}

struct Lesson10: View {
    @StateObject var viewModel = Lesson10ViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Button("start") {
                    viewModel.verifyState.send("00:12")
                    viewModel.remainingTime = 12
                    viewModel.start()
                }
                .font(.title)
            case .data(let time):
                Text(time)
                    .font(.title)
                    .foregroundColor(.green)
            case .error(let error):
                Text(error.localizedDescription)
            }
        }
    }
}

class Lesson10ViewModel: ObservableObject {
    @Published var state: ViewState<String> = .loading
    @Published var remainingTime: Int = 0
    
    let verifyState = PassthroughSubject<String, Never>()
    var cancellable: AnyCancellable?
    var timerCancellable: AnyCancellable?
    
    
    init() {
        bind()
    }
    
    func bind() {
        cancellable = verifyState
            .sink(receiveValue: { [unowned self] value in
                if !value.isEmpty {
                    state = .data(value)
                } else {
                    state = .error(NSError(domain: "Error time", code: 101))
                }
            })
    }
    
    func start() {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "00:ss"
        
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [unowned self] _ in
                if remainingTime > 10 {
                    remainingTime -= 1
                    verifyState.send("00:\(String(remainingTime))")
                } else if remainingTime > 0 {
                        remainingTime -= 1
                        verifyState.send("00:0\(String(remainingTime))")
                } else {
                    timerCancellable?.cancel()
                }
            })
    }
}

#Preview {
    Lesson10()
}
