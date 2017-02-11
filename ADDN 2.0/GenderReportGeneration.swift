//
//  ReportOptionExtensionForGenderReportGeneration.swift
//  ADDN 2.0
//
//  Created by Jay on 10/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

extension ReportOptionController {
    func generateReportForGender(fetchedData: FetchedDataForReport) -> [UIView] {
        var views = [UIView]()
        
        let local_id_id = fetchedData.local_id_ids
        let patients = fetchedData.patients
        let visits = fetchedData.visits
        
        if self.selectedAttributeIndexes[0].count == 0 || self.selectedAttributeIndexes[0].count == Constants.SELECTABLE_GENDERS.count {
            
            var numbers = [Double](repeating: 0.0, count: Constants.SELECTABLE_GENDERS.count)
            var totalAgesInDays = [Double](repeating: 0.0, count: Constants.SELECTABLE_GENDERS.count)
            var totalDurationsInDays = [Double](repeating: 0.0, count: Constants.SELECTABLE_GENDERS.count)
            var HbA1cRanges = [[Double]](repeating: [], count:  Constants.SELECTABLE_GENDERS.count)
            
            for i in 0..<local_id_id.count {
                if let gender = patients[i].gender, let index = Constants.TITLES_FOR_GENDERS.index(of: gender) {
                    numbers[index] += 1
                    totalAgesInDays[index] += Double(patients[i].age_at_export_in_days!)
                    totalDurationsInDays[index] += Double(patients[i].diabetes_duration_in_days!)
                    HbA1cRanges[index].append(Double(
                        FlagForHbA1cTypes ? (visits[i].hba1c_iffc)! : (visits[i].hba1c_ngsp)!
                    ))
                }
            }
            
            var groupedValues = [[String]]()
            for i in 0..<numbers.count {
                groupedValues.append([numbers[i].description, String(format: "%.2f",(Double(totalAgesInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",(Double(totalDurationsInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",HbA1cRanges[i].average),HbA1cRanges[i].median.description + "0","\(HbA1cRanges[i].min)0~\(HbA1cRanges[i].max)0"])
            }
            
            //table
            views.append(Tabular(dataPoint: ["Total number", "Mean Age (years)","Mean Duration (years)","Mean HbA1c","Median HbA1c","HbA1c Range"], groupedvalues: groupedValues, titles: Constants.TITLES_FOR_GENDERS))
            //pie
            views.append(PieChart(dataPoints: Constants.SELECTABLE_GENDERS, values: numbers, title: "Gender Distribution"))

            if self.ranges[3].count > 0 {
                
                var groupedvalues = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: 2)
                
                for i in 0..<self.ranges[3].count {
                    let min = (self.ranges[3][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[3][i].0)
                    let max = (self.ranges[3][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[3][i].1)
                    
                    for j in 0..<local_id_id.count {
                        let value = Double((FlagForHbA1cTypes ? visits[j].hba1c_iffc : visits[j].hba1c_ngsp)!)
                        if let gender = patients[j].gender, let index = Constants.TITLES_FOR_GENDERS.index(of: gender) {
                            if value > min && value <= max {
                                groupedvalues[index][i] += 1
                            }
                        }
                    }
                }
                
                var titleForHbA1cRanges = [String]()
                for hba1cRange in self.ranges[3] {
                    let datapoint: String = (hba1cRange.0 == Double.leastNormalMagnitude ? "" : hba1cRange.0.description) + "~" + (hba1cRange.1 == Double.greatestFiniteMagnitude ? "" : hba1cRange.1.description)
                    titleForHbA1cRanges.append(datapoint)
                }
                
                views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvalues, labels: Constants.SELECTABLE_GENDERS,title:"HbA1c Range Distribution"))
                
            }
        }else {
            let title = Constants.TITLES_FOR_GENDERS[selectedAttributeIndexes[0].first!]
            
            var number = 0
            var totalAgesInDays = 0
            var totalDurationsInDays = 0
            var HbA1cRanges = [Double]()
            
            for i in 0..<local_id_id.count {
                if let gender = patients[i].gender, gender == title{
                    number += 1
                    totalAgesInDays += Int(patients[i].age_at_export_in_days!)
                    totalDurationsInDays += Int(patients[i].diabetes_duration_in_days!)
                    HbA1cRanges.append(Double(
                        FlagForHbA1cTypes ? (visits[i].hba1c_iffc)! : (visits[i].hba1c_ngsp)!
                    ))
                }
            }
            
            let values = [number.description, String(format: "%.2f",(Double(totalAgesInDays)/Double(number)/365)),String(format: "%.2f",(Double(totalDurationsInDays)/Double(number)/365)),String(format: "%.2f",HbA1cRanges.average),HbA1cRanges.median.description + "0","\(HbA1cRanges.min)0~\(HbA1cRanges.max)0"]
            
            //show table view
            views.append(Tabular(dataPoint: ["Total number", "Mean Age (years)","Mean Duration (years)","Mean HbA1c","Median HbA1c","HbA1c Range"], values: values, titles: [title]))

            if self.ranges[3].count > 0 {
                
                var values = [Double](repeating: 0.0, count: self.ranges[3].count)
                for i in 0..<self.ranges[3].count {
                    let min = (self.ranges[3][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[3][i].0)
                    let max = (self.ranges[3][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[3][i].1)
                    
                    for j in 0..<local_id_id.count {
                        let value = Double((FlagForHbA1cTypes ? visits[j].hba1c_iffc : visits[j].hba1c_ngsp)!)
                        if let gender = patients[j].gender, gender == title {
                            if value > min && value <= max {
                                values[i] += 1
                            }
                        }
                    }
                }
                
                var titleForHbA1cRanges = [String]()
                for hba1cRange in self.ranges[3] {
                    let datapoint: String = (hba1cRange.0 == Double.leastNormalMagnitude ? "" : hba1cRange.0.description) + "~" + (hba1cRange.1 == Double.greatestFiniteMagnitude ? "" : hba1cRange.1.description)
                    titleForHbA1cRanges.append(datapoint)
                }
                
                views.append(PieChart(dataPoints: titleForHbA1cRanges, values: values, title: "HbA1c Range Distribution"))
            }
        }

        
        return views
    }
    
}
