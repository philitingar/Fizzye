//
//  ContentViewModel.swift
//  Fizzye
//
//  Created by Timea on 2025-01-21.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    let monthMapping: [String: Int] = [
        "A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6,
        "G": 7, "H": 8, "J": 9, "K": 10, "L": 11, "M": 12
    ]

    let suggary: Int = 0
    let zero: Int = 1
    let diet: Int = 2
    
    enum ExpirationType {
        case sugaryPet, sugaryGlass, diet, zero
    }
    
    func isvalidMonthAndDay(code: String, dayOfYearString: String) -> Bool {
        guard code.count == 1, dayOfYearString.count == 3 else {
            return false
        }
        let monthCode = String(code.prefix(1))
        guard let month = monthMapping[monthCode] else {
            return false
        }
        guard let dayOfYear = Int(dayOfYearString), dayOfYear > 0, dayOfYear <= 366 else {
            return false
        }
        let year = 2020
        guard let startDate = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1)) else {
            return false
        }
        guard let calculatedDate = Calendar.current.date(byAdding: .day, value: dayOfYear - 1, to: startDate) else {
            return false
        }
        let calculatedMonth = Calendar.current.component(.month, from: calculatedDate)
        
        return calculatedMonth == month
    }
    
    func calculateExpirationDate(code: String, selectedOption: Int) -> String {
        //guard code.count >= 5 else { return "Invalid code. Code must be 5 characters long." }
        
        let manufactureDate = convertCodeToDate(code: code)
        
        //let shelfLife = selectedOption == 1 ? 3 : 9
        var expirationType: ExpirationType
        switch selectedOption {
        case zero:
            expirationType = ExpirationType.zero
        case diet:
            expirationType = ExpirationType.diet
        case suggary:
            expirationType = ExpirationType.sugaryGlass
        default:
            expirationType = ExpirationType.sugaryGlass
        }
        
        guard let expirationDate = addExpirationToDate(date: manufactureDate, type: expirationType) else {
            return "Error: Could not calculate expiration date."
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: expirationDate)
    }
    
    func checkExpirationStatus(expirationDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let expirationDateObj = dateFormatter.date(from: expirationDate) else {
            return "Invalid Date"
        }
        let currentDate = Date()
        if expirationDateObj < currentDate {
            return String(localized: "This is expired. \nExpired drinks usually don't cause any health risks if consumed. Depending on how much time has passed since the expiration date the drink can taste salty. \nBy our tests 1-3 months past expiration can taste a bit more fizzy and with hints of saltiness, 3-6 months past expiration can taste like a salty soda drink with a hint of Dr Pepper and for more then 6 months past expiration it will probably taste like a very salty and fizzy soda, with no taste of DrPepper.")
        } else {
            return String(localized: "This drink is good to consume.")
        }
    }
    func getExpirationDetailsForDifferentContainers(code: String, selectedOption: Int, expirationDate: String) -> [String: String] {
        let manufactureDate = convertCodeToDate(code: code)
        
        let glassBottleExpirationDate = addExpirationToDate(date: manufactureDate, type: ExpirationType.sugaryGlass)!
        let petBottleExpirationDate = addExpirationToDate(date: manufactureDate, type: ExpirationType.sugaryPet)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let glassBottleString = dateFormatter.string(from: glassBottleExpirationDate)
        let petBottleString = dateFormatter.string(from: petBottleExpirationDate)
        let forAllContainers = expirationDate
        
        var expirationDetails = [String: String]()
        
        if selectedOption == suggary { //sugar
            expirationDetails[String(localized: "Glass Bottle/Cans expire in")] = glassBottleString
            expirationDetails[String(localized: "PET Bottles expire in")] = petBottleString
        } else if selectedOption == zero { //zero
            expirationDetails[String(localized: "Expires in")] = forAllContainers
        } else { //diet
            expirationDetails[String(localized: "Expires in")] = forAllContainers
        }
        return expirationDetails
    }
    
    // imeplements the logic to convert a manufactury code to a manufactury Date and is reused across the code.
    func convertCodeToDate(code: String) -> Date {
        let yearCode = String(code.dropFirst().prefix(1))
        let dayOfYearString = String(code.suffix(3))
        
        let yearValue = Int(yearCode)
        // get current year (example 2024) remove the 4 and change it for the yearValue in the code example if current year is 2024 and yearValue is 3 -> 2024 -> 2023
        let year = Int(2020) + yearValue!
        
        let dayOfYear = Int(dayOfYearString)
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let startDate = calendar.date(from: DateComponents(year: year, month: 1, day: 1))
        let manufactureDate = calendar.date(byAdding: .day, value: (dayOfYear! - 1), to: startDate!)
        
        return manufactureDate!
    }
    
    func addExpirationToDate(date: Date, type: ExpirationType) -> Date? {
        var shelfLife: Int
        switch type {
        case ExpirationType.sugaryPet, ExpirationType.zero:
            shelfLife = 4
        case ExpirationType.sugaryGlass:
            shelfLife = 9
        case ExpirationType.diet:
            shelfLife = 3
        }
        
        shelfLife = shelfLife - 1
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar.date(byAdding: .month, value: shelfLife, to: date)
    }
}
