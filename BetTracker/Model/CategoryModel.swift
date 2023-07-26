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
}

extension Category: DatabaseValueConvertible { }
