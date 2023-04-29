//
//  BetDetail.swift
//  BetTrackerUI
//
//  Created by Adam Zapiór on 04/03/2023.
//

import SwiftUI

struct BetDetail: View {
    let category: String
    let text: String

    var body: some View {
        HStack {
            Text(category)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
                .bold()
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.body)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
        }
    }
}
