# BetTracker

**Welcome to BetTracker, the smartest way to track and manage all your bets in one sleek interface!**

The application will be available soon on the App Store.

## Tech Stack used to build app:
- [x] SwiftUI
- [x] Combine
- [x] GRDB
- [x] UserDefaults
- [x] UserNotifications

## Architecture

![BetTracker-desgin-pattern](https://i.imgur.com/l8jhy08.png)

This app is designed with <b>MVVM pattern</b>. Apart from using the MVVM architecture, I was inspired by one of the articles on Medium, which additionally separates the communication layer with the database and allows for easier use of the Respository mock in potential tests.

![Link to the article](https://medium.com/macoclock/swiftui-mvvm-clean-architecture-e976ad3577b5)

## Features

- **Bet Management:** Easily create bets and betslips with parameters like team or name, amount, odds, tax, category, event and notification dates, and additional notes. Users can also mark bets as won or lost and delete them or their notifications before triggering.
- **Search & Sort:** Quickly search bets by name or by one of the default sorting criteria.
- **User Profiles & Customization:** Users can personalize their profiles with custom avatars and usernames, and set their default tax rate.
- **Statistics:** Keep track of various stats including balance and averages of expenditures, wins, and losses over weekly, monthly, yearly, or all-time periods.
- **Exporting:** Easily export bet history to a .CSV file.

## Screenshots

![BetTracker](https://i.imgur.com/EllNmU8.png)
![BetTracker](https://i.imgur.com/xKex2f1.png)
![BetTracker](https://i.imgur.com/CUQH2c2.png)
