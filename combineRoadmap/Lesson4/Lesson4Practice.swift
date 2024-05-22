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
                        viewModel.addToBasket(item: item)
                    }
                }
            }
            
            Text("BASKET")
            List(viewModel.basket) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(String(item.price))
                    Spacer()
                    Button("-") {
                        viewModel.removeFromBasket(item: item)
                    }
                }
            }
            Text("Total Price - \(viewModel.getBasketTotalPrice())")
            Button("Delete all basket items") {
                viewModel.deleteAllBasketItems()
            }
        }
    }
}

class Lesson4PracticeViewModel: ObservableObject {
    @Published var shop: [Item] = [
        Item(name: "bread", price: 100),
        Item(name: "milk", price: 200),
        Item(name: "coffee", price: 300),
        Item(name: "chocolate", price: 400),
        Item(name: "water", price: 500),
        Item(name: "sandwich", price: 600),
    ]
    @Published var basket: [Item] = []
    
    func addToBasket(item: Item) {
        if let index = shop.firstIndex(where: { $0 == item }) {
            let item = shop.remove(at: index)
            basket.append(item)
        }
    }
        
    func removeFromBasket(item: Item) {
        if let index = basket.firstIndex(where: { $0 == item }) {
            let item = basket.remove(at: index)
            shop.append(item)
        }
    }
    
    func getBasketTotalPrice() -> String {
        var total = 0
        basket.forEach {
            total += $0.price
        }
        return String(total)
    }
    
    func deleteAllBasketItems() {
        basket = []
    }
}

struct Item: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let price: Int
}

#Preview {
    Lesson4Practice()
}
