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
        HStack(alignment: .center) {
            Text("\(carb.carbs)")
                .padding(10)
            Text(carb.dateDateStr)
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
