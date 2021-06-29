//
//  ContentView.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/6/21.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    private var healthStore: HealthStore?
    @State private var carbs: [CarbModel] = [CarbModel]()
    
    init() {
        healthStore = HealthStore()
    }
    
    var body: some View {
        NavigationView {
            List(carbs, id: \.id) { carb in
                HStack(alignment: .center) {
                    Text("\(carb.carbs)")
                    Spacer()
                    Text(carb.date, style: .date)
                        .opacity(0.5)
                }
                .accessibility(identifier: "carbsListLabel")
            }
            .navigationBarTitle("Carbs List")
            .onAppear {
                if let healthStore = healthStore {
                    healthStore.requestAuthorization { success in
                        if success {
                            healthStore.calculateCarbs { statisticsCollection in
                                if let statisticsCollection = statisticsCollection {
                                    print(statisticsCollection)     // FIXME: TODO: Change to logging.
                                    fetchCarbsFromStatistics(statisticsCollection)
                                }
                            }
                        }
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
