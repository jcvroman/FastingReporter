//
//  FastListView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/21/22.
//

import SwiftUI

struct FastListView: View {
    @ObservedObject var fastListVM: FastListViewModel
    
    var body: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                fastListListView
                    .refreshable() { fetchFastList() }
            } else {
                // NOTE: Fallback on earlier versions.
                fastListListView
            }

            if fastListVM.isLoading { LoadingView() }
        }
        // .overlay(fastListTitle, alignment: .top)
        .overlay(fastListHeader, alignment: .topLeading)
    }

    // MARK: - Sub Views.
    private var fastListListView: some View {
        List(fastListVM.fastList) { carb in
            CarbFastRowView(carb: carb)
        }
    }

    private var fastListTitle: some View {
        // NOTE: Used frame w/ minWidth & alignment to get table like columns.
        HStack {
            Text("Fast List")
        }
        .font(.system(size: 16).bold())   // NOTE: Use fixed font size so not resized like dynamic ones.
        .shadow(color: Color.primary.opacity(0.5), radius: 5, x: 5, y: 5)
    }

    private var fastListHeader: some View {
        VStack {
            fastListTitle

            // NOTE: Used frame w/ minWidth & alignment to get table like columns.
            HStack {
                Text("Date")
                    .frame(minWidth: 190, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
                Spacer(minLength: 10)
                Text("Fast")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40))
            }
            .font(.system(size: 16).lowercaseSmallCaps())   // NOTE: Use fixed font size so not resized like dynamic ones.
            .shadow(color: Color.primary.opacity(0.5), radius: 5, x: 5, y: 5)
        }
    }

    // MARK: - Actions.
    private func fetchFastList() {
        fastListVM.requestAuthorization { success in
            if success {
                fastListVM.fetchFastList()
            }
        }
    }
}

// MARK: - Previews.
struct FastListView_Previews: PreviewProvider {
    static var previews: some View {
        FastListView(fastListVM: FastListViewModel())
    }
}
