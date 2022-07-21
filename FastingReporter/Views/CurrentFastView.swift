//
//  CurrentFastView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/21/22.
//

import SwiftUI

struct CurrentFastView: View {
    @ObservedObject var currentFastVM: CurrentFastViewModel

    // BUG: TODO: Only going back 1 day for a carb entry. Should go back further....
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.secondary.opacity(0.1))
                    .cornerRadius(10.0)
                    .frame(minHeight: 60, idealHeight: 60, maxHeight: 60, alignment: .center)
                    .shadow(color: Color.primary.opacity(0.5), radius: 10, x: 10, y: 10)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            VStack {
                Text("Fast: ")
                    .font(.largeTitle).fontWeight(.heavy)
                    .foregroundColor(.primary)
                + Text("\(currentFastVM.carbsFirst?.date ?? Date(), style: .timer)")
                    .font(.largeTitle).fontWeight(.heavy)
                    .foregroundColor(.secondary)
            }
        }
        .shadow(color: Color.primary.opacity(0.5), radius: 5, x: 5, y: 5)
        .alert(item: $currentFastVM.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
}

// MARK: - Previews.
struct CurrentFastView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentFastView(currentFastVM: CurrentFastViewModel())
    }
}
