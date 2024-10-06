//
//  BetsDetailsViewModelsProtocol.swift
//  BetTracker
//
//  Created by Adam Zapiór on 06/10/2024.
//

import Foundation

protocol BetsDetailsViewModelsProtocol: ObservableObject {
    var isAlertSet: Bool { get set }
    var buttonState: BetStatus { get set }

    func deleteBet()
    func deleteBetNotification()
}
