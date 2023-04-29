//
//  PredictedProfit.swift
//  BetTracker
//
//  Created by Adam Zapiór on 12/04/2023.
//

import SwiftUI

struct PredictedProfit: View {

    let text: String
    
    var body: some View {
        HStack {
            Text("Przewidywana wygrana:")
                .foregroundColor(Color.ui.onPrimaryContainer)
                .bold()
            Spacer()
            Text(text)
                .bold()
                .foregroundColor(Color.ui.scheme)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(Color.ui.onPrimary) // TODO: id 5
                        .padding(.horizontal, -16)
                        .padding(.vertical, -8)
                    
                }
        }
        .padding(.top, 12)
        .padding(.horizontal, 12)
    }
}

