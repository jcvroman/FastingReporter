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
        HStack {
            Text("\(carb.carbs)")
                .padding(15)
            VStack(alignment: .leading) {
                Text(carb.dateDateStr)
                Text(carb.dateTimeStr)
            }
            Spacer(minLength: 10)
            Text("\(carb.diffHoursMinutesStr)")
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
