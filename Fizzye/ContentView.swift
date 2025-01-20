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
                                .background(self.selectedOption == index ? Color.pepperRed : Color.gray).opacity(0.9)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 15)
                
                TextField("Enter first 4 digits here, ex: A023", text: $inputText)
                    .padding()
                    .background(Color.gray)
                    .foregroundStyle(.white)
                    .textCase(.uppercase)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.top, 20)
                Button {
                    expirationDate = calculateExpirationDate(code: inputText)
                }label: {
                    Text("Calculate Expiration")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .foregroundColor(.white)
                        .background(.gray)
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
        guard code.count >= 4 else { return "Invalid code." }
        
        let monthCode = String(code.prefix(1))
        let yearCode = String(code.dropFirst().prefix(1))
        let dayOfYear = String(code.dropFirst(2).prefix(2))
        
        guard let month = monthMapping[monthCode] else { return "Invalid month code."}
        let year = 2020 + (Int(yearCode) ?? 2000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
       guard let startDate = Calendar.current.date(from: DateComponents(year:year, month: 1, day: 1)) else {
            return "Invalid Year"
        }
       
        guard let dayInt = Int(dayOfYear) else {
            return "Invalid day of year"
        }
        guard let manufactureDate = Calendar.current.date(byAdding: .day, value: dayInt, to: startDate) else {
            return "Error: Could not calculate manufacture date"
        }
            let shelfLife: Int
            if selectedOption == 1 {
                shelfLife = 3
            } else {
                shelfLife = 9
            }
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
