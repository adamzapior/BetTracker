//
//  CategoryRowView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 23/10/2024.
//

import Foundation
import SwiftUI

struct CategoryRowView: View {
    let category: CategoryModel

    var body: some View {
        HStack {
            Image(systemName: category.systemImage)
                .foregroundStyle(Color.ui.scheme)
                .frame(width: 16, alignment: .center)
                .padding(.trailing, 12)
            Text(category.name)
            Spacer()
        }
    }
}
