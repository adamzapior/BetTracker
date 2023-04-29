//
//  BetDetailHeader.swift
//  BetTrackerUI
//
//  Created by Adam Zapiór on 04/03/2023.
//

import SwiftUI

struct BetDetailHeader: View {
    let onDelete: () -> Void

    var body: some View {
        ZStack {
            Text("Bet details")
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(Color.red)
                    .opacity(0.7)
                    .font(.title2)
                    .onTapGesture {
                        onDelete()
                    }
            }
            .padding(.trailing, 18)
        }
    }
}
