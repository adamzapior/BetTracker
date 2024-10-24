//
//  TagRowView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 23/10/2024.
//

import Foundation
import SwiftUI

struct TagRowView: View {
    let tag: TagModel

    var body: some View {
        HStack {
            Circle()
                .fill(tag.color)
                .frame(width: 12, height: 12)
                .frame(alignment: .center)
                .padding(.trailing, 12)
            Text(tag.name)
            Spacer()
        }
    }
}
