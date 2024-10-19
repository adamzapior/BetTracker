//
//  File.swift
//  BetTracker
//
//  Created by Adam Zapiór on 18/10/2024.
//

import SwiftUI

struct CancelButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.ui.onError)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
