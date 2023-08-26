//
//  BetslipDetailsVM.swift
//  BetTracker
//
//  Created by Adam Zapiór on 27/07/2023.
//

import Foundation

class BetslipDetailsVM: ObservableObject {
    
    let bet: BetslipModel
    let defaults = UserDefaultsManager.path
    
    @Published
    var isShowingAlert = false

    
    var buttonState: BetButtonState = .uncleared

    enum BetButtonState {
        case uncleared
        case won
        case lost
    }
    
    var defaultCurrency: Currency = .usd
    
    init(bet: BetslipModel) {
        self.bet = bet
        
        setup()
    }
    
    // MARK: -  VM setup methods:

    private func setup() {
//        checkButtonState()
//        isNotificationInFuture()
        loadDefaultCurrency()
    }

    private func loadDefaultCurrency() {
        defaultCurrency = Currency(rawValue: defaults.get(.defaultCurrency)) ?? .usd
    }
    
    // MARK: -  Bet edit/delete methods:
    
    // TODO: !!!!

    
}
