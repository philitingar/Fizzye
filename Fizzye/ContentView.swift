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
                TextField("Enter first 4 digits here, ex: A023", text: .constant(""))
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
