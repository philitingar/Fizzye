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

    var body: some View {
        VStack {
            Text("Code: \(code)")
                .padding()
                .foregroundStyle(.white)
            let expirationDetails = vm.getExpirationDetailsForDifferentContainers(code: code, selectedOption: selectedOption, expirationDate: expirationDate)
            ForEach(expirationDetails.keys.sorted(), id: \.self) { key in
                Text("\(key): \(expirationDetails[key]!)")
                    .padding()
                    .foregroundStyle(.white)
            }
            Text(vm.checkExpirationStatus(expirationDate: expirationDate))
                .padding()
                .foregroundStyle(.white)
                
            Spacer()
        }
        .padding()
    }
}

#Preview {
    BottomSheetView(expirationDate: "2024-12-31", code: "A5001", selectedOption: -1)
}
