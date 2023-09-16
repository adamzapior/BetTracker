//
//  CategoryModel.swift
//  BetTracker
//
//  Created by Adam Zapiór on 26/07/2023.
//

import Foundation
import GRDB

enum Category: String, CaseIterable {
    case football
    case basketball
    case f1
    case tenis
    case volleyball
    case baseball
    case golf
    case boxing
    case mma
    case swimming
    case cycling
    case hockey
    case gymnastic
    case esport
    case cricket
    case athletics
    case other
}

extension Category: DatabaseValueConvertible { }
