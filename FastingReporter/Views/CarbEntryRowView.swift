//
//  CarbEntryRowView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/16/22.
//

import SwiftUI

struct CarbEntryRowView: View {
    let carb: CarbViewModel

    var body: some View {
        // NOTE: Used frame w/ minWidth & alignment to get table like columns.
        HStack {
            VStack(alignment: .leading) {
                Text(carb.dateDateStr)
                Text(carb.dateTimeStr)
            }
            .frame(minWidth: 190, alignment: .leading)
            Text("\(carb.carbs)")
                .frame(minWidth: 30, alignment: .leading)
            Spacer(minLength: 10)
            Text("\(carb.diffHoursMinutesStr)")
                .frame(minWidth: 50, alignment: .trailing)
        }
        .accessibility(identifier: "carbsEntryRowLabel")
        .font(.body)
        .foregroundColor(carb.fastFontColor)
    }
}

struct CarbEntryRowView_Previews: PreviewProvider {
    static var previews: some View {
        CarbEntryRowView(carb: CarbViewModel(carb: CarbModel.init(carbs: 70, date: Date())))
    }
}
