//
//  ReminderInput.swift
//  BetTracker
//
//  Created by Adam Zapiór on 01/04/2023.
//

import SwiftUI

struct ReminderInput: View {
    
    var bodyText: String
    
    
    @State
    private var isOn = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            VStack {
                HStack {
                    HStack {
                            Text(bodyText)
                                .foregroundColor(Color.ui.onPrimaryContainer)
                        Spacer()
                        Toggle("", isOn: $isOn)
                            .frame(maxWidth: 60)
                            .tint(Color.ui.scheme)
                            .padding(.trailing, -12)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    
                    
                }
            }
        }
    }
}

