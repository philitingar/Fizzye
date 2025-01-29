//
//  Validation.swift
//  Fizzye
//
//  Created by Timea on 2025-01-22.
//

import Foundation

protocol ValidationRule {
    func validate(_ input: String) -> String?
}

struct StringValidationRule: ValidationRule {
    func validate(_ input: String) -> String? {
        let isValidFormat = input.count == 5 && input.prefix(1).allSatisfy {$0.isLetter} && input.suffix(4).allSatisfy {$0.isNumber}
        return isValidFormat ? nil : String(localized:"The code must be in the format 'L1234'.")
    }
}

struct IncrementalValidationRule: ValidationRule {
    func validate(_ input: String) -> String? {
        if input.count > 5 {
            return String(localized:"The code cannot exceed 5 characters.")
        }
        if let firstChar = input.first, !firstChar.isLetter {
            return String(localized:"The code must start with a letter.")
        }
        if input.count > 1{
            for char in input.dropFirst() {
                if !char.isNumber {
                    return String(localized:"The remaining characters must consist of numbers only.")
                }
            }
        }
       return nil
    }
}
