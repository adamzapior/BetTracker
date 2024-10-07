//
//  BetsDetailRowView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 06/10/2024.
//

import SwiftUI

struct BetsDetailRowView: View {
    let labelText: String
    var valueText: String
    var currency: String?

    var body: some View {
        VStack {
            HStack {
                Text(labelText)
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color.ui.onPrimaryContainer)
                    .padding(.leading, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text(valueText + " " + (currency ?? ""))
                    .font(.body)
                    .padding(.leading, 12)
                    .frame(alignment: .center)
                Spacer()
                Spacer()
            }
            .padding(.top, 4)
            .padding(.bottom, 2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.ui.onPrimary)
        )
        .standardShadow()
    }
}
