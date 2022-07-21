//
//  CarbsDailyListView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/21/22.
//

import SwiftUI

struct CarbsDailyListView: View {
    @ObservedObject var carbsDailyListVM: CarbsDailyListViewModel

    var body: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                carbsDailyListListView
                    .refreshable() { fetchDailyCarbs() }
            } else {
                // NOTE: Fallback on earlier versions.
                carbsDailyListListView
            }

            if carbsDailyListVM.isLoading { LoadingView() }
        }
        .overlay(carbsDailyListHeader, alignment: .topLeading)
    }

    // MARK: - Sub Views.
    private var carbsDailyListListView: some View {
        List(carbsDailyListVM.carbsListCVM) { carb in
            CarbDailyRowView(carb: carb)
        }
     }

    private var carbsDailyListHeader: some View {
        // NOTE: Used frame w/ minWidth & alignment to get table like columns.
        HStack {
            Text("Date")
                .frame(minWidth: 190, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
            Text("Carbs")
                .frame(minWidth: 30, alignment: .leading)
        }
        .font(.system(size: 16).lowercaseSmallCaps())
        .shadow(color: Color.primary.opacity(0.5), radius: 5, x: 5, y: 5)
    }

    // MARK: - Actions.
    private func fetchDailyCarbs() {
        carbsDailyListVM.requestAuthorization { success in
            if success {
                carbsDailyListVM.fetchDailyCarbs()
            }
        }
    }
}

// MARK: - Previews.
struct CarbsDailyListView_Previews: PreviewProvider {
    static var previews: some View {
        CarbsDailyListView(carbsDailyListVM: CarbsDailyListViewModel())
    }
}
