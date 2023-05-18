//
//  AddBetButton.swift
//  BetTracker
//
//  Created by Adam Zapiór on 02/04/2023.
//

import SwiftUI

struct AddBetButton: View {
    let text: String
    var action: () -> Void

    var body: some View {
        Text(text)
            .font(.title2)
            .bold()
            .foregroundColor(Color.ui.background)
            .frame(minWidth: 200, minHeight: 56, alignment: .center)
            .padding(.horizontal, 48)
            .padding(.vertical, 3)
            .clipShape(RoundedRectangle(cornerRadius: 150))
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.ui.onPrimaryContainer)
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
        
            .onTapGesture {
                action()
            }
    }
}

struct AddDeclineButton: View {
    let text: String
    var action: () -> Void

    var body: some View {
        Text(text)
            .font(.title2)
            .bold()
            .foregroundColor(Color.red)
            .frame(minWidth: 75, minHeight: 40, alignment: .center)
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .clipShape(RoundedRectangle(cornerRadius: 150))
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(Color.ui.secondary)
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
        
            .onTapGesture {
                action()
            }
    }
}
