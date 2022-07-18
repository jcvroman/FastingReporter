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
        HStack {
            Text("\(Constants.defaultCarbBlankStr)")
                .padding(15)
            VStack(alignment: .leading) {
                Text(carb.dateDateStr)
            }
            Spacer(minLength: 10)
            Text("\(carb.diffHoursMinutesStr)")
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
