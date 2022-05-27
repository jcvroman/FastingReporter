//
//  ContentView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/6/21.
//

import HealthKit
import SwiftUI

struct ContentView: View {
    // NOTE: Think of main/root views as a table of contents (i.e. not too little or too much here).
    private var healthStore: HealthStore?
    @State private var carbs: [CarbModel] = [CarbModel]()
    @State private var carbsList: [CarbModel] = [CarbModel]()

    init() {
        healthStore = HealthStore()
    }

    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: 0) {
                    Color.clear
                }
                VStack {
                    Text("Current Fast:")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                    Text("\(carbsList.first?.date ?? Date(), style: .timer)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                }
            }
            carbsEntryListView
            carbsDailyListView
        }
        .onAppear(perform: fetchHealthStore)
    }

    // MARK: - Sub Views.
    private var carbsEntryListView: some View {
        List(carbsList) { carb in
            HStack {
                Text("\(carb.carbs)")
                Spacer()
                Text(carb.date, style: .date)
                Spacer()
                Text(carb.date, style: .time)
            }
            .accessibility(identifier: "carbsEntryListLabel")
            .font(.body)
        }
        .navigationTitle("Carbs Entry List")
    }

    private var carbsDailyListView: some View {
        List(carbs, id: \.id) { carb in
            HStack(alignment: .center) {
                Text("\(carb.carbs)")
                Spacer()
                Text(carb.date, style: .date)
            }
            .accessibility(identifier: "carbsDailyListLabel")
            .font(.body)
        }
        .navigationTitle("Carbs Daily List")
     }

    // MARK: - Actions.
    private func fetchHealthStore() {
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    healthStore.calculateCarbs { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            print("statisticsCollection:", statisticsCollection)     // FIXME: TODO: Change to logging.
                            fetchCarbsFromStatistics(statisticsCollection)
                        }
                    }
                    // healthStore.calculateCurrentFast()
                    healthStore.calculateCurrentFast { querySamples in
                        updateUIFromQuerySamples(querySamples)
                    }
                }
            }
        }
    }

    private func fetchCarbsFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            let gram = statistics.sumQuantity()?.doubleValue(for: .gram())
            let carb = CarbModel(carbs: Int(gram ?? 0), date: statistics.startDate)
            carbs.append(carb)
        }
        carbs.sort()
    }

    private func updateUIFromQuerySamples (_ querySamples: [HKSample]) {
        for sample in querySamples {
            if let hkQuanitySample = sample as? HKQuantitySample {
                let carbValue = CarbModel(carbs: Int(hkQuanitySample.quantity.doubleValue(for: .gram())),
                                          date: hkQuanitySample.startDate)
                carbsList.append(carbValue)
            }
        }
    }
}

// MARK: - Previews.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
