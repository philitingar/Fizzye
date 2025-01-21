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
    @State private var selectedOption = 0 // To track selected option
    @State private var inputText = ""
    @State private var expirationDate = ""
    @State private var isSheetPresented = false
    @State private var showAlert = false
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
                    let monthCode = String(inputText.prefix(1))
                    let dayOfTheYearString = String(inputText.suffix(3))
                    if vm.isvalidMonthAndDay(code: monthCode, dayOfYearString: dayOfTheYearString) {
                        expirationDate = vm.calculateExpirationDate(code: inputText, selectedOption: selectedOption)
                        isSheetPresented = true
                    } else {
                        showAlert = true
                    }
                    inputText = ""
                } label: {
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
            .sheet(isPresented: $isSheetPresented) {
                BottomSheetView(expirationDate: expirationDate)
                    .presentationDetents([.height(450)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color.pepperRed)
                    .cornerRadius(80)
            
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Incorrect format."), message: Text("Make sure you put in the correct format"), dismissButton: .default(Text("OK"))
                      )
            }
        }
         
    }
}


#Preview {
    ContentView()
}
