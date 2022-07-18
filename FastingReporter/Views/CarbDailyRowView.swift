//
//  CarbDailyRowView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/16/22.
//

import SwiftUI

struct CarbDailyRowView: View {
    let carb: CarbViewModel

    var body: some View {
        // NOTE: Used frame w/ minWidth & alignment to get table like columns.
        HStack(alignment: .center) {
            Text(carb.dateDateStr)
                .frame(minWidth: 190, alignment: .leading)
            Text("\(carb.carbs)")
                .frame(minWidth: 30, alignment: .leading)
                // .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
        }
        .accessibility(identifier: "carbsDailyRowLabel")
        .font(.body)
    }
}

struct CarbDailyRowView_Previews: PreviewProvider {
    static var previews: some View {
        CarbDailyRowView(carb: CarbViewModel(carb: CarbModel.init(carbs: 270, date: Date())))
    }
}
