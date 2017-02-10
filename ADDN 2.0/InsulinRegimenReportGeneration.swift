//
//  InsulinRegimenReportGeneration.swift
//  ADDN 2.0
//
//  Created by Jay on 10/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

extension ReportOptionController{
    func generateReportForInsulinRegimen(fetchedData: FetchedDataForReport) -> [UIView] {
        var views = [UIView]()
        
        let local_id_id = fetchedData.local_id_ids
        let patients = fetchedData.patients
        let visits = fetchedData.visits
        
        let selectedIndex = selectedAttributeIndexes[2].count == 0 ? Array(0...Constants.SELECTABLE_INSULIN_REGIMEN.count - 1) : selectedAttributeIndexes[2]
        
        //        Insulin Regimen
        if FlagForInsulinRegimenBreakDown && self.ranges[0].count > 0{
            var numbers = [[Double]](repeating: [Double](repeating: 0.0, count: Constants.SELECTABLE_INSULIN_REGIMEN.count), count: self.ranges[0].count)
            var totalAgesInDays = [[Double]](repeating: [Double](repeating: 0.0, count: Constants.SELECTABLE_INSULIN_REGIMEN.count), count: self.ranges[0].count)
            var totalDurationsInDays = [[Double]](repeating: [Double](repeating: 0.0, count: Constants.SELECTABLE_INSULIN_REGIMEN.count), count: self.ranges[0].count)
            var HbA1cRanges = [[[Double]]](repeating: [[Double]](repeating: [], count: Constants.SELECTABLE_INSULIN_REGIMEN.count), count: self.ranges[0].count)
                
            var ageRanges = [(Double,Double)]()
                
            //initial ageRanges
            for i in 0..<self.ranges[0].count {
                let min = (self.ranges[0][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[0][i].0) * 365
                let max = (self.ranges[0][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[0][i].1) * 365
                ageRanges.append((min,max))
            }
                
            for i in 0..<local_id_id.count {
                for j in 0..<ageRanges.count{
                    if let ageInDays = patients[i].age_at_export_in_days {
                        if Double(ageInDays) > ageRanges[j].0 && Double(ageInDays) <= ageRanges[j].1 {
                            if let insulinRegimen = visits[i].insulin_regimen, let index = Constants.TITLES_FOR_INSULIN_REGIMEN.index(of: insulinRegimen) {
                                numbers[j][index] += 1
                                totalAgesInDays[j][index] += Double(patients[i].age_at_export_in_days!)
                                totalDurationsInDays[j][index] += Double(patients[i].diabetes_duration_in_days!)
                                HbA1cRanges[j][index].append(Double(
                                    FlagForHbA1cTypes ? (visits[i].hba1c_iffc)! : (visits[i].hba1c_ngsp)!
                                ))
                            }
                        }
                    }
                }
            }
                
            var titleForAgeRanges = [String]()
            for range in self.ranges[0] {
                let title: String = (range.0 == Double.leastNormalMagnitude ? "" : range.0.description) + "~" + (range.1 == Double.greatestFiniteMagnitude ? "" : range.1.description) + " years old"
                titleForAgeRanges.append(title)
            }
            
            var groupedValuesForBarChart = [[Double]](repeating: [], count: self.ranges[0].count)
            var dataPointsForCharts = [String]()
            for i in selectedIndex {
                dataPointsForCharts.append(Constants.SELECTABLE_INSULIN_REGIMEN[i])
                for j in 0..<ageRanges.count{
                    groupedValuesForBarChart[j].append(numbers[j][i])
                }
            }
                
            views.append(BarChartWithFormatter(dataPoints: dataPointsForCharts, groupedValues: groupedValuesForBarChart, labels: titleForAgeRanges, title: "Insulin Regimen break down"))
            
            
//            var groupedValuesForTabular = [[String]]()
//            for i in selectedIndex {
//                groupedValuesForTabular.append([numbers[i].description, String(format: "%.2f",(Double(totalAgesInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",(Double(totalDurationsInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",HbA1cRanges[i].average),HbA1cRanges[i].median.description + "0","\(HbA1cRanges[i].min)0~\(HbA1cRanges[i].max)0"])
//            }
            
//            views.append(Tabular(dataPoint: ["Total number", "Mean Age (years)","Mean Duration (years)","Mean HbA1c","Median HbA1c","HbA1c Range"], groupedvalues: groupedValuesForTabular, titles: dataPointsForCharts))
            
            
                
            if self.ranges[3].count > 0 {
                var groupedvalues = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: Constants.SELECTABLE_INSULIN_REGIMEN.count)
                    
            for i in 0..<self.ranges[3].count {
                let min = (self.ranges[3][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[3][i].0)
                let max = (self.ranges[3][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[3][i].1)
                        
                for j in 0..<local_id_id.count {
                    let value = Double((FlagForHbA1cTypes ? visits[j].hba1c_iffc : visits[j].hba1c_ngsp)!)
                            
                    if value > min && value <= max {
                        if let insulinRegimen = visits[j].insulin_regimen, let index = Constants.TITLES_FOR_INSULIN_REGIMEN.index(of: insulinRegimen) {
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
                    
                    
                var groupedValuesForBarChart = [[Double]]()
                for selected in selectedIndex {
                    groupedValuesForBarChart.append(groupedvalues[selected])
                }
                
                
                views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedValuesForBarChart, labels: dataPointsForCharts,title:"HbA1c Range Distribution"))
                
            }

        }else {
            //no break down
            var numbers = [Double](repeating: 0.0, count: Constants.SELECTABLE_INSULIN_REGIMEN.count)
            var totalAgesInDays = [Double](repeating: 0.0, count: Constants.SELECTABLE_INSULIN_REGIMEN.count)
            var totalDurationsInDays = [Double](repeating: 0.0, count: Constants.SELECTABLE_INSULIN_REGIMEN.count)
            var HbA1cRanges = [[Double]](repeating: [], count:  Constants.SELECTABLE_INSULIN_REGIMEN.count)
                
            for i in 0..<local_id_id.count {
                if let insulinRegimen = visits[i].insulin_regimen, let index = Constants.TITLES_FOR_INSULIN_REGIMEN.index(of: insulinRegimen) {
                    numbers[index] += 1
                    totalAgesInDays[index] += Double(patients[i].age_at_export_in_days!)
                    totalDurationsInDays[index] += Double(patients[i].diabetes_duration_in_days!)
                    HbA1cRanges[index].append(Double(
                            FlagForHbA1cTypes ? (visits[i].hba1c_iffc)! : (visits[i].hba1c_ngsp)!
                    ))
                }
            }
            
            
            
            
            var dataPointsForCharts = [String]()
            var valuesForPieChart = [Double]()
            for selected in selectedIndex {
                dataPointsForCharts.append(Constants.SELECTABLE_INSULIN_REGIMEN[selected])
                valuesForPieChart.append(numbers[selected])
            }
                
            views.append(PieChart(dataPoints: dataPointsForCharts, values: valuesForPieChart, title: "Insulin Regimen Distribution"))
            
            var groupedValues = [[String]]()
            for i in selectedIndex {
                groupedValues.append([numbers[i].description, String(format: "%.2f",(Double(totalAgesInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",(Double(totalDurationsInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",HbA1cRanges[i].average),HbA1cRanges[i].median.description + "0","\(HbA1cRanges[i].min)0~\(HbA1cRanges[i].max)0"])
            }
            
            views.append(Tabular(dataPoint: ["Total number", "Mean Age (years)","Mean Duration (years)","Mean HbA1c","Median HbA1c","HbA1c Range"], groupedvalues: groupedValues, titles: dataPointsForCharts))
            
            
            
            if self.ranges[3].count > 0 {
                var groupedvalues = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: Constants.SELECTABLE_INSULIN_REGIMEN.count)
                    
                for i in 0..<self.ranges[3].count {
                    let min = (self.ranges[3][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[3][i].0)
                    let max = (self.ranges[3][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[3][i].1)
                        
                    for j in 0..<local_id_id.count {
                        let value = Double((FlagForHbA1cTypes ? visits[j].hba1c_iffc : visits[j].hba1c_ngsp)!)
                            
                        if value > min && value <= max {
                            if let insulinRegimen = visits[j].insulin_regimen, let index = Constants.TITLES_FOR_INSULIN_REGIMEN.index(of: insulinRegimen) {
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
                    
                var groupedValuesForBarChart = [[Double]]()
                for selected in selectedIndex {
                    groupedValuesForBarChart.append(groupedvalues[selected])
                }

                
                views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedValuesForBarChart, labels: dataPointsForCharts,title:"HbA1c Range Distribution"))
                    
                }
                
            }
        return views
    }
}
