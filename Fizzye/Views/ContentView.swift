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
    @StateObject private var vm = ContentViewModel()
    @State private var selectedOption = -1
    @State private var inputText = ""
    @State private var expirationDate = ""
    @State private var isSheetPresented = false
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @State private var errorMessage: String?
    let options = ["Sugary", "Zero"]
    private let validationRule = IncrementalValidationRule()
    
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
                            // .background(self.selectedOption == index ? Color.pepperRed : Color.black).opacity(0.9)
                                .background(
                                    Group {
                                        if index == 0 {
                                            self.selectedOption == index ? Color.pepperRed : Color.gray.opacity(0.2)
                                        } else if index == 1 {
                                            self.selectedOption == index ? Color.black : Color.gray.opacity(0.2)
                                        }
                                    }
                                )
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    Group {
                                        if selectedOption == index {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.pepperRed, lineWidth: 2)
                                        }
                                    }
                                )
                            
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 15)
                
                TextField("Enter first 5 digits here, ex: A1234", text: $inputText)
                    .padding()
                    .background(Color.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.top, 20)
                    .onChange(of: inputText) { oldvalue, newValue in
                        let uppercasedValue = newValue.uppercased()
                        let filteredValue = uppercasedValue.filter { $0.isLetter || $0.isNumber }
                        inputText = String(filteredValue.prefix(5))
                        
                        if !inputText.isEmpty {
                            errorMessage = validationRule.validate(filteredValue)
                        } else {
                            errorMessage = nil
                        }
                       
                    }
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 15)
                }
                Button {
                    if selectedOption == -1 {
                        showAlert = true
                        alertMessage = "Please select the type of drink before calculating."
                    } else {
                        let monthCode = String(inputText.prefix(1))
                        let dayOfTheYearString = String(inputText.suffix(3))
                        if vm.isvalidMonthAndDay(code: monthCode, dayOfYearString: dayOfTheYearString) {
                            expirationDate = vm.calculateExpirationDate(code: inputText, selectedOption: selectedOption)
                            isSheetPresented = true
                        } else {
                            showAlert = true
                            alertMessage = "The code you entered is incorrect. Make sure you put in the correct format."
                        }
                    }
                    inputText = ""
                    selectedOption = -1
                } label: {
                    Text(inputText.isEmpty || errorMessage != nil || inputText.count < 5 ? "Enter details" : "Calculate Expiration")
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
                .disabled(inputText.isEmpty || errorMessage != nil || inputText.count < 5)
                Spacer()
            }
            .sheet(isPresented: $isSheetPresented) {
                BottomSheetView(expirationDate: expirationDate)
                    .presentationDetents([.height(450)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color.pepperRed)
                    .cornerRadius(80)
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}


#Preview {
    ContentView()
}
