//
//  ViewState.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 27.05.2024.
//

import Foundation

enum ViewState<Model> {
    /// Начало, загрузки нет
    case start
    /// Загрузка
    case loading
    /// Данные пришли
    case data(_ data: Model)
    /// Ошибка
    case error(_ error: Error)
}
