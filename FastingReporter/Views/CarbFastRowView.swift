//
//  CarbFastRowView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/17/22.
//

import SwiftUI

struct CarbFastRowView: View {
    let carb: CarbViewModel

    var body: some View {
        // NOTE: Used frame w/ minWidth & alignment to get table like columns.
        HStack {
            Text(carb.dateDateStr)
                .frame(minWidth: 190, alignment: .leading)
            Spacer(minLength: 10)
            Text("\(carb.diffHoursMinutesStr)")
                .frame(minWidth: 50, alignment: .trailing)
        }
        .accessibility(identifier: "carbsFastRowLabel")
        .font(.body)
        .foregroundColor(carb.fastFontColor)
    }
}

struct CarbFastRowView_Previews: PreviewProvider {
    static var previews: some View {
        CarbFastRowView(carb: CarbViewModel(carb: CarbModel.init(carbs: 70, date: Date())))
    }
}
