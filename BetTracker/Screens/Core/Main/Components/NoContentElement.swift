//
//  NoContentElement.swift
//  BetTrackerUI
//
//  Created by Adam Zapiór on 03/03/2023.
//

import SwiftUI

struct NoContentElement: View {
    let text: String

    var body: some View {
        VStack {
            Text(text)
        }
        .padding(.vertical, 48)
    }
}
