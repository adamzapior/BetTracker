//
//  WonRateRow.swift
//  BetTracker
//
//  Created by Adam Zapiór on 14/05/2023.
//

import SwiftUI


struct WonRateRow: View {
    
    let cellTitle: String
//    let icon: String
    let valueText: String

    var body: some View {
        ZStack {
            VStack {
                Text("\(cellTitle)")
                    .font(.subheadline)
                    .foregroundColor(Color.ui.onPrimaryContainer)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(alignment: .center) {
                    
                    Text("\(valueText)%")
                        .font(.headline)
                        .foregroundColor(Color.ui.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 6)
                }
                .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.ui.onPrimary)
            }
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 3, y: 2)

        }
    }
}

