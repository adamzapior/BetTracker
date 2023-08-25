//
//  EventDateRow.swift
//  BetTracker
//
//  Created by Adam Zapiór on 13/05/2023.
//

import SwiftUI

struct EventDateRow: View {

    let icon: String
    let labelText: String
    let dateText: String
    let actionButtonIcon: String
    let actionButtonColor: Color

    let action: () -> Void

    init(
        icon: String,
        labelText: String,
        dateText: String,
        actionButtonIcon: String,
        actionButtonColor: Color,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.labelText = labelText
        self.dateText = dateText
        self.actionButtonColor = actionButtonColor
        self.actionButtonIcon = actionButtonIcon
        self.action = action
    }

    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "\(icon)")
                    .font(.title2)
                    .foregroundColor(Color.ui.scheme)
                    .padding(.trailing, 12)
                    .frame(width: 36, height: 36)

                Text(labelText)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.ui.secondary)
                    .padding(.vertical, 16)
                Text(dateText)
                    .font(.subheadline)
                    .foregroundColor(Color.ui.onPrimaryContainer)
                Spacer()
                Image(systemName: "\(actionButtonIcon)")
                    .font(.title)
                    .foregroundColor(Color.ui.secondary)
                    .onTapGesture {
                        action()
                    }
            }
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        Color.ui.onPrimary
                    )
            }

            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }

}



