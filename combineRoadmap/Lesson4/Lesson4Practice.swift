//
//  Lesson4Practice.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 22.05.2024.
//

import SwiftUI

struct Lesson4Practice: View {
    @StateObject var viewModel = Lesson4PracticeViewModel()
    
    var body: some View {
        VStack {
            Text("SHOP")
            List(viewModel.shop) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Button("+") {
                        
                    }
                    Button("-") {
                        
                    }
                }
            }
            
            Text("BASKET")
            List(viewModel.basket) { item in
                Text(item.name)
            }
        }
    }
}

class Lesson4PracticeViewModel: ObservableObject {
    @Published var shop: [Item] = [
        Item(name: "bread"),
        Item(name: "milk"),
        Item(name: "coffee"),
        Item(name: "chocolate"),
        Item(name: "water"),
        Item(name: "sandwich"),
    ]
    @Published var basket: [Item] = []
    
    func addToBasket(item: Item) {
        if let index = shop.firstIndex(where: { $0 == item }) {
            let item = shop.remove(at: index)
            basket.append(item)
    }
        
        func removeFromBasket(item: Item) {
            
        }
}

struct Item: Identifiable, Equatable {
    let id = UUID()
    let name: String
}

#Preview {
    Lesson4Practice()
}
