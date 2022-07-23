//
//  CarbsEntryListView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/21/22.
//

import SwiftUI

struct CarbsEntryListView: View {
    @ObservedObject var carbsEntryListVM: CarbsEntryListViewModel

    var body: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                carbsEntryListListView
                    .refreshable() { fetchEntryCarbs() }
            } else {
                // NOTE: Fallback on earlier versions.
                carbsEntryListListView
            }

            if carbsEntryListVM.isLoading { LoadingView() }
        }
        .overlay(carbsEntryListHeader, alignment: .topLeading)
    }

    // MARK: - Sub Views.
    private var carbsEntryListListView: some View {
        List(carbsEntryListVM.carbsListCVM) { carb in
            CarbEntryRowView(carb: carb)
        }
    }

    private var carbsEntryListHeader: some View {
        // NOTE: Used frame w/ minWidth & alignment to get table like columns.
        HStack {
            Text("Date")
                .frame(minWidth: 190, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
            Text("Carbs")
                .frame(minWidth: 30, alignment: .leading)
            Spacer(minLength: 10)
            Text("Fast")
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40))
        }
        .font(.system(size: 16).lowercaseSmallCaps())
        .shadow(color: Color.primary.opacity(0.5), radius: 5, x: 5, y: 5)
    }

    // MARK: - Actions.
    private func fetchEntryCarbs() {
        carbsEntryListVM.requestAuthorization { success in
            if success {
                carbsEntryListVM.fetchEntryCarbs()
            }
        }
    }
}

// MARK: - Previews.
struct CarbsEntryListView_Previews: PreviewProvider {
    static var previews: some View {
        CarbsEntryListView(carbsEntryListVM: CarbsEntryListViewModel())
    }
}
