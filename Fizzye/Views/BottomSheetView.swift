//
//  BottomSheetView.swift
//  Fizzye
//
//  Created by Timea on 2025-01-21.
//

import SwiftUI

struct BottomSheetView: View {
    @StateObject private var vm = ContentViewModel()
    let expirationDate: String
    let code: String
    let selectedOption: Int
    let expirationStatus: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Code: \(code)")
                    .padding(.bottom)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                let expirationDetails = vm.getExpirationDetailsForDifferentContainers(code: code, selectedOption: selectedOption, expirationDate: expirationDate)
                ForEach(expirationDetails.keys.sorted(), id: \.self) { key in
                    Text("\(key): \(expirationDetails[key]!)")
                        .bold()
                        .foregroundStyle(.black)
                        .padding(.bottom, 2)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // --- Simplified Status Display ---
                // The HStack is still useful for centering the text
                HStack {
                    Text(expirationStatus)
                        .underline(true, color: .black)
                        .foregroundStyle(.black)
                        .font(.system(size: 20, weight: .bold))
                    // --- REMOVED Button and conditional arrow logic ---
                }
                .padding(.top)
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .center) // Center status line
                if expirationStatus == String(localized: "This is expired.") {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(alignment: .top) {
                            Image(systemName: "heart.slash.circle")
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.8))
                                .frame(width: 30)
                            Text("Expired drinks usually don't cause any health risks if consumed.")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "timer")
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.8))
                                .frame(width: 30)
                            Text("**1-3 months past expiration:** Depending on how much time has passed, the drink can start to taste salty. It might also seem a bit more fizzy and have hints of saltiness.")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "calendar")
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.8))
                                .frame(width: 30)
                            Text("**3-6 months past expiration:** The taste may resemble a salty soda drink with only a hint of the original flavour.")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.8))
                                .frame(width: 30)
                            Text("**More than 6 months past expiration:** It will likely taste like a very salty and fizzy soda, with no other flavours remaining.")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .foregroundStyle(.black)
                    .padding()
                    .font(.system(size: 17))
                    .cornerRadius(10)
                    .padding(.top) // Add space above the info box
                }
                // --- End of Conditional Info Text Section ---
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    BottomSheetView(
        expirationDate: "2023-01-15", // Example expired date
        code: "A3001",
        selectedOption: 0, // Sugary
        expirationStatus: "This is expired." // Provide the status directly
    )
    
}

#Preview {
    BottomSheetView(
        expirationDate: "2025-12-31", // Example not expired date
        code: "M4365",
        selectedOption: 1, // Zero
        expirationStatus: "This drink is good to consume." // Provide the status directly
    )
    
}
