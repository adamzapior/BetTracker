//
//  MarkButton.swift
//  BetTracker
//
//  Created by Adam Zapiór on 24/06/2023.
//

import SwiftUI

import SwiftUI

struct MarkButton: View {
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
            .frame(minWidth: 130, minHeight: 36, alignment: .center)
            .padding(.horizontal, 64)
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(backgroundColor)
                    .opacity(0.6)
//                backgroundColor
//                    .opacity(0.7)
//                RoundedRectangle(cornerRadius: 25)
//                    .stroke(style: StrokeStyle(lineWidth: 1))
//                    .foregroundColor(Color.ui.secondary)

            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct MarkWonButton: View {
    let text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.title3)
                .bold()
            Spacer()
            Image(systemName: "checkmark.square.fill")
                .font(.title)
        }
            .padding(.horizontal, 36)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        Color.ui.scheme
                    )
                    .opacity(0.2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.secondary, lineWidth: 0.2)
                    )
            }

            .frame(maxWidth: .infinity)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)

    }
}


struct MarkLostButton: View {
    let text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.title3)
                .bold()
            Spacer()
            Image(systemName: "minus.square.fill")
                .font(.title)
        }
            .padding(.horizontal, 36)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        Color.red
                    )
                    .opacity(0.2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.secondary, lineWidth: 0.2)
                    )
            }

            .frame(maxWidth: .infinity)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)

    }
}

