//
//  AddBetButton.swift
//  BetTracker
//
//  Created by Adam Zapiór on 02/04/2023.
//

import SwiftUI

struct AddBetButton: View {
    let text: String
    let backgroundColor: Color

    init(text: String, backgroundColor: Color = .clear) {
        self.text = text
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        Text(text)
            .font(.title3)
            .bold()
            .frame(width: 200, height: 33,alignment: .center)
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .background {
                backgroundColor
                RoundedRectangle(cornerRadius: 25)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(Color.ui.secondary)
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

