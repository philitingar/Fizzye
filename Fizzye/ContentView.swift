//
//  ContentView.swift
//  Fizzye
//
//  Created by Timea Bartha on 9/12/24.
//

import SwiftUI
extension Color {
    static let pepperRed = Color(red: 137 / 255, green: 0 / 255, blue: 36 / 255)
}
struct ContentView: View {
    @State private var selectedOption = 0 // To track selected option
    @State private var inputText = ""
    @State private var expirationDate = ""
    let monthMapping: [String: Int] = [
        "A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6,
        "G": 7, "H": 8, "I": 9, "J": 10, "K": 11, "L": 12
    ]
    let options = ["Sugary", "Zero"]
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center,  spacing: 1) {
                Image("pepper")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 400, maxHeight: 400)
                    .opacity(0.5)
                Text("This app only works with DrPepper produced in the USA.")
                    .font(.title3)
                    .foregroundColor(.pepperRed)
                    .bold()
                    .multilineTextAlignment(.center)
                    .opacity(0.7)
                    .padding(.horizontal, 15)
            }.padding()
            VStack {
                HStack {
                    ForEach(0..<options.count, id: \.self) { index in
                        Button {
                            selectedOption = index
                        } label: {
                            Text(self.options[index])
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(self.selectedOption == index ? Color.pepperRed : Color.black).opacity(0.9)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.pepperRed, lineWidth: 2)
                                )
                            
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 15)
                
                TextField("Enter first 5 digits here, ex: L3328", text: $inputText)
                    .padding()
                    .background(Color.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.top, 20)
                    .onChange(of: inputText) { oldvalue, newValue in
                        let filtered = newValue.uppercased().filter { $0.isLetter || $0.isNumber }
                        inputText = String(filtered.prefix(5))
                    }
                Button {
                    expirationDate = calculateExpirationDate(code: inputText)
                }label: {
                    Text("Calculate Expiration")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.pepperRed, lineWidth: 2)
                        )
                        .padding(.top, 20)
                }
                Spacer()
            }
        }
         
    }

    func calculateExpirationDate(code: String) -> String {
        guard code.count >= 5 else { return "Invalid code.Code must be 5 characters long." }
        
        let monthCode = String(code.prefix(1))
        let yearCode = String(code.dropFirst().prefix(1))
        let dayOfYearString = String(code.suffix(3))
        
        guard let month = monthMapping[monthCode] else { return "Invalid month code."}
        guard let yearValue = Int(yearCode), yearValue >= 0 else { return "Invalid year code." }
        let year = 2020 + yearValue
        
        guard let dayOfYear = Int(dayOfYearString), dayOfYear > 0, dayOfYear <= 366 else {
            return "Invalid day of year."
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
       guard let startDate = Calendar.current.date(from: DateComponents(year:year, month: 1, day: 1)),
             let manufactureDate = Calendar.current.date(byAdding: .day, value: dayOfYear - 1, to: startDate) else {
            return "Error calculating manufacture date."
        }
    
        let shelfLife = selectedOption == 1 ? 3 : 9
        
        guard let expirationDate = Calendar.current.date(byAdding: .month, value: shelfLife, to: manufactureDate) else {
                return "Error: Could not calculate expiration date"
            }
        print(" Expiration \(expirationDate)")
        print(" ----")
        print("Manufacure date \(manufactureDate)")
        return dateFormatter.string(from: expirationDate)
   
    }
}


#Preview {
    ContentView()
}
