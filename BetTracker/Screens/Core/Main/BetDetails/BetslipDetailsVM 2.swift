//
//  BetslipDetailsVM.swift
//  BetTracker
//
//  Created by Adam Zapiór on 27/07/2023.
//

import Foundation

class BetslipDetailsVM: ObservableObject {
    
    enum BetslipButtonState {
        case uncleared
        case won
        case lost
    }
    
    let bet: BetslipModel
    
    init(bet: BetslipModel) {
        self.bet = bet
        
        //        checkButtonState()
    }
    
    var buttonState: BetslipButtonState = .uncleared
    
    @Published
    var isShowingAlert = false
    
    var currency = UserDefaultsManager.defaultCurrencyValue
    
    //    func deleteBet(bet: BetslipModel) {
    //        BetslipDao.deleteBetslip(bet: bet)
    //    }
    //
    //    func removeNotification() {
    //        UserNotificationsService().removeNotification(notificationId: bet.betslipNotificationID ?? "")
    //    }
    //
    //    func checkButtonState() {
    //        if bet.isWon == nil {
    //            buttonState = .uncleared
    //        } else if bet.isWon == true {
    //            button
}
