//
//  ContentViewModelTest.swift
//  FizzyeTests
//
//  Created by Timea on 2025-01-24.
//

import Testing
@testable import Fizzye
import Foundation


struct ContentViewModelTest {
    @Suite("test validations") struct ContentViewModelValidationRuleTests {
        @Test func testValidCodeTest() async throws {
            let vm = ContentViewModel()
            let result = vm.isvalidMonthAndDay(code: "A", dayOfYearString: "001")
            #expect(result == true)
        }
        @Test func testInvalidCodeTest() async throws {
            let vm = ContentViewModel()
            var result = vm.isvalidMonthAndDay(code: "AB", dayOfYearString: "001")
            #expect(result == false)
            
            result = vm.isvalidMonthAndDay(code: "A", dayOfYearString: "00188")
            #expect(result == false)
            
            result = vm.isvalidMonthAndDay(code: "I", dayOfYearString: "001")
            #expect(result == false)
            
            result = vm.isvalidMonthAndDay(code: "A", dayOfYearString: "400")
            #expect(result == false)
            
            result = vm.isvalidMonthAndDay(code: "A", dayOfYearString: "267")
            #expect(result == false)

        }
    }
    
    @Suite("test code to date conversion") struct ContentViewModelConvertCodeToDateTests {
        @Test func testCodeConvertCalculation() async throws {
            let vm = ContentViewModel()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            var result = vm.convertCodeToDate(code: "A5001")
            #expect(result == dateFormatter.date(from: "2025-01-01"))
            
            result = vm.convertCodeToDate(code: "B5032")
            #expect(result == dateFormatter.date(from: "2025-02-01"))
        }
        
        @Test func testCasdfa() async throws {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            
            let input = dateFormatter.date(from: "2025-01-01")!
            let expetedOutput = calendar.date(byAdding: .month, value: 2, to: input)
            #expect(expetedOutput == dateFormatter.date(from: "2025-03-01"))
        }
    }

    @Suite("test code to expiration addition") struct ContentViewModelAddExpirationToManufatureTests {
        @Test func testExpirationAdditionCalculation() async throws {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let input = dateFormatter.date(from: "2025-01-01")!
            
            let vm = ContentViewModel()
            var result = vm.addExpirationToDate(date: input, type: ContentViewModel.ExpirationType.zero)!
            
            #expect(result == dateFormatter.date(from: "2025-04-01"))
        }
    }


    @Suite("test expiration calculation") struct ContentViewModelExpirationCalculationTests {
        @Test func testExpirationCalculation() async throws {
            let vm = ContentViewModel()
            var result = vm.calculateExpirationDate(code: "A5001", selectedOption: 1)
            #expect(result == "2025-04-01")
            
            result = vm.calculateExpirationDate(code: "A5001", selectedOption: 2)
            #expect(result == "2025-03-01")
            
            result = vm.calculateExpirationDate(code: "A5001", selectedOption: 0)
            #expect(result == "2025-09-01")
        }
    }

    @Suite("test expiration for different bottles") struct ContentViewModelExpirationForDifferentBottlesTests {
        @Test func getExpirationDateForDifferentBottles() async throws {
            let vm = ContentViewModel()
            var result = vm.getExpirationDetailsForDifferentContainers(code: "A5001", selectedOption: 1, expirationDate: "2025-04-01")
            #expect(result == ["Any containers have expired in":"2025-04-01"])
            
            result = vm.getExpirationDetailsForDifferentContainers(code: "A5001", selectedOption: 2, expirationDate: "2025-03-01")
            #expect(result == ["Any containers have expired in":"2025-03-01"])
    /*
            result = vm.getExpirationDetailsForDifferentContainers(code: "A5001", selectedOption: 0, expirationDate: "2025-09-01")
            #expect(result == ["Glass Bottle/Cans expire in":"2025-09-02", "PET Bottles expire in":"2025-04-02"] )
            */
                        
        }
    }
}
