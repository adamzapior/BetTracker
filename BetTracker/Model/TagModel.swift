//  TagModel.swift
//  BetTracker
//
//  Created by Adam Zapiór on 23/10/2024.
//
import Foundation
import SwiftUI

struct TagModel: Identifiable, Equatable {
    var id: Int64?
    let name: String
    let colorComponents: ColorComponents
    var indexPath: Int
    
    var color: Color {
        Color(red: colorComponents.red,
              green: colorComponents.green,
              blue: colorComponents.blue,
              opacity: colorComponents.alpha)
    }
    
    init(id: Int64? = nil, name: String, color: UIColor, indexPath: Int = 0) {
        self.id = id
        self.name = name
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.colorComponents = ColorComponents(red: red, green: green, blue: blue, alpha: alpha)
        self.indexPath = indexPath
    }
}

struct ColorComponents {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

extension TagModel {
    static func == (lhs: TagModel, rhs: TagModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.indexPath == rhs.indexPath &&
            lhs.colorComponents.red == rhs.colorComponents.red &&
            lhs.colorComponents.green == rhs.colorComponents.green &&
            lhs.colorComponents.blue == rhs.colorComponents.blue &&
            lhs.colorComponents.alpha == rhs.colorComponents.alpha
    }
}
