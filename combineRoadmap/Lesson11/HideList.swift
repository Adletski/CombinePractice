//
//  HideList.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 27.05.2024.
//

import SwiftUI

struct HideListIndicatorsViewModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollIndicators(.hidden)
        } else {
            content
        }
    }
}

/// Расширение для использования
extension View {
    func hideListIndicatorsView() -> some View {
        modifier(HideListIndicatorsViewModifier())
    }
}
