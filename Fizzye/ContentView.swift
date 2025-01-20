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
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.top, 20)
                Spacer()
            }
        }
         
    }
    // #890024
}


#Preview {
    ContentView()
}
