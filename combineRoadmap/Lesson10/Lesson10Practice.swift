//
//  Lesson10Practice.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 24.05.2024.
//

import SwiftUI
import Combine

enum ViewState2<Model> {
    case loading
    case data(_ data: Model)
    case error(_ error: Error)
}

struct Lesson10Practice: View {
    @StateObject var viewModel = Lesson10PracticeViewModel()
    @State var isAnimating = false
    @State var showAnimation = false
    
    var body: some View {
        VStack {
            Text("time left 00:00")
            Spacer()
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .data(let data):
                if showAnimation {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                                        .animation(Animation.linear(duration: 3).repeatCount(1, autoreverses: false), value: isAnimating)
                                        .onAppear {
                                            self.isAnimating = true
                                        }
                } else {
                    List(viewModel.dataToView, id: \.self) { item in
                        Text(item)
                    }
                }
            case .error(let error):
                Text(error.localizedDescription)
            }
            Spacer()
            Button("START") {
                startAnimation()
                viewModel.verifyState.send("00:59")
            }
        }
    }
    
    func startAnimation() {
        showAnimation = true
        isAnimating = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showAnimation = false
        }
    }
}

class Lesson10PracticeViewModel: ObservableObject {
    @Published var state: ViewState2<String> = .loading
    @Published var remainingTime = 59
    @Published var dataToView = [
        "Цена продукта 100 руб",
        "Цена продукта 100 руб",
        "Цена продукта 100 руб",
        "Цена продукта 100 руб",
        "Цена продукта 100 руб",
        "Цена продукта 100 руб",
        "Цена продукта 100 руб"
    ]
    
    var verifyState = PassthroughSubject<String, Never>()
    var cancellable: AnyCancellable?
    var timerCancellable: AnyCancellable?
    
    init() {
        bind()
    }
    
    func bind() {
        cancellable = verifyState.sink(receiveValue: { [unowned self] value in
            if !value.isEmpty {
                state = .data(value)
            } else {
                state = .error(NSError(domain: "Error time", code: 101))
            }
        })
    }
    
    func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [unowned self] _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    timerCancellable?.cancel()
                }
            })
    }
    
}

#Preview {
    Lesson10Practice()
}
