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
    @State private var showInfoText = false

    var body: some View {
        ScrollView {
            VStack {
                Text("Code: \(code)")
                    .padding()
                    .foregroundStyle(.white)
                let expirationDetails = vm.getExpirationDetailsForDifferentContainers(code: code, selectedOption: selectedOption, expirationDate: expirationDate)
                ForEach(expirationDetails.keys.sorted(), id: \.self) { key in
                    Text("\(key): \(expirationDetails[key]!)")
                        .bold()
                        .foregroundStyle(.white)
                }
                HStack {
                    Text(vm.checkExpirationStatus(expirationDate: expirationDate))
                        .underline(true, color: .white)
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .bold))
                    if vm.checkExpirationStatus(expirationDate: expirationDate) == "This is expired." {
                        Button {
                            showInfoText.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.white)
                        }
                        if showInfoText {
                            Image(systemName: "arrow.down")
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                }
                .padding(.top)
                .padding(.bottom)
                if showInfoText {
                    Text("Expired drinks usually don't cause any health risks if consumed. Depending on how much time has passed since the expiration date the drink can taste salty. \nBy our tests 1-3 months past expiration can taste a bit more fizzy and with hints of saltiness, 3-6 months past expiration can taste like a salty soda drink with a hint of flavour and for more than 6 months past expiration it will probably taste like a very salty and fizzy soda, with no other flavours at all.")
                        .foregroundStyle(.white)
                        .padding()
                        .font(.system(size: 18))
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    BottomSheetView(expirationDate: "2024-12-31", code: "A5001", selectedOption: -1)
}
