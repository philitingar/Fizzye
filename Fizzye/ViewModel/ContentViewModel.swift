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
    
    func calculateExpirationDate(code: String, selectedOption: Int) -> String {
        guard code.count >= 5 else { return "Invalid code. Code must be 5 characters long." }
        
        let monthCode = String(code.prefix(1))
        let yearCode = String(code.dropFirst().prefix(1))
        let dayOfYearString = String(code.suffix(3))
        
        guard let month = monthMapping[monthCode] else { return "Invalid month code." }
        guard let yearValue = Int(yearCode), yearValue >= 0 else { return "Invalid year code." }
        let year = 2020 + yearValue
        
        guard let dayOfYear = Int(dayOfYearString), dayOfYear > 0, dayOfYear <= 366 else {
            return "Invalid day of year."
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1)),
              let manufactureDate = Calendar.current.date(byAdding: .day, value: dayOfYear, to: startDate) else {
            return "Error calculating manufacture date."
        }
        
        let shelfLife = selectedOption == 1 ? 3 : 9
        
        guard let expirationDate = Calendar.current.date(byAdding: .month, value: shelfLife, to: manufactureDate) else {
            return "Error: Could not calculate expiration date."
        }
        print("this is the manufacturing date: \(manufactureDate)")
        print ("-------")
        print("this is the expiration date: \(expirationDate)")
        return dateFormatter.string(from: expirationDate)
    }
    func isvalidMonthAndDay(code: String, dayOfYearString: String) -> Bool {
        guard code.count >= 1, dayOfYearString.count == 3 else {
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
        guard let    calculatedDate = Calendar.current.date(byAdding: .day, value: dayOfYear, to: startDate) else {
            return false
        }
        let calculatedMonth = Calendar.current.component(.month, from: calculatedDate)
        
        return calculatedMonth == month
    }
}
