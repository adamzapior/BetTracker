//
//  BookmakerRowView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 24/10/2024.
//

import Foundation
import SwiftUI

struct BookmakerRowView: View {
    let bookmaker: BookmakerModel

    var body: some View {
        HStack {
            Circle()
                .fill(bookmaker.color)
                .frame(width: 12, height: 12)
                .frame(alignment: .center)
                .padding(.trailing, 12)
            Text(bookmaker.name)
            Spacer()
        }
    }
}
