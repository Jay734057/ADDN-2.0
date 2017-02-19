//
//  DiabetesReportGeneration.swift
//  ADDN 2.0
//
//  Extension for generating the diabetes report
//
//  Created by Jay on 10/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

extension ReportOptionController{
    func generateReportForDiabetes(fetchedData: FetchedDataForDetailedReport) -> [UIView] {
        var views = [UIView]()
        
        //all retrieved data
        let local_id_id = fetchedData.local_id_ids
        let patients = fetchedData.patients
        let visits = fetchedData.visits
        
        //check the number of set Diabetes ranges
        if self.ranges[1].count > 0 {
            
            //variables for storing analysis result
            var numbers = [Double](repeating: 0.0, count: self.ranges[1].count)
            var totalAgesInDays = [Double](repeating: 0.0, count: self.ranges[1].count)
            var totalDurationsInDays = [Double](repeating: 0.0, count: self.ranges[1].count)
            var HbA1cRanges = [[Double]](repeating: [], count:  self.ranges[1].count)
            var diabeteDurationRanges = [(Double,Double)]()
            
            //initial ranges
            for i in 0..<self.ranges[1].count {
                let min = (self.ranges[1][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[1][i].0) * 365
                let max = (self.ranges[1][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[1][i].1) * 365
                diabeteDurationRanges.append((min,max))
            }
            
            //analyze the data
            for i in 0..<local_id_id.count {
                for index in 0..<diabeteDurationRanges.count {
                    if let diabeteDurationInDays = patients[i].diabetes_duration_in_days {
                        if Double(diabeteDurationInDays) > diabeteDurationRanges[index].0 && Double(diabeteDurationInDays) <= diabeteDurationRanges[index].1 {
                            numbers[index] += 1
                            totalAgesInDays[index] += Double(patients[i].age_at_export_in_days!)
                            totalDurationsInDays[index] += Double(patients[i].diabetes_duration_in_days!)
                            HbA1cRanges[index].append(Double(
                                self.FlagForHbA1cTypes ? (visits[i].hba1c_iffc)! : (visits[i].hba1c_ngsp)!
                            ))
                        }
                    }
                }
            }
            
            //setup the input for tables and charts
            var titleForDiabeteDurationRanges = [String]()
            for range in self.ranges[1] {
                let title: String = (range.0 == Double.leastNormalMagnitude ? "" : range.0.description) + "~" + (range.1 == Double.greatestFiniteMagnitude ? "" : range.1.description) + " years"
                titleForDiabeteDurationRanges.append(title)
            }
            
            //group the analysis results for the table
            var groupedValues = [[String]]()
            for i in 0..<numbers.count {
                groupedValues.append([numbers[i].description, String(format: "%.2f",(Double(totalAgesInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",(Double(totalDurationsInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",HbA1cRanges[i].average),HbA1cRanges[i].median.description + "0","\(HbA1cRanges[i].min)0~\(HbA1cRanges[i].max)0"])
            }
            
            //add table to the report
            views.append(Tabular(dataPoint: ["Total number", "Mean Age (years)","Mean Duration (years)","Mean HbA1c","Median HbA1c","HbA1c Range"], groupedvalues: groupedValues, titles: titleForDiabeteDurationRanges))
            
            //add pie chart for diabetes distribution to the report
            views.append(PieChart(dataPoints: titleForDiabeteDurationRanges, values: numbers, title: "Diabete Duration Distribution"))
            
            //if HbA1c ranges are set, generate the bar chart for HbA1c duration distribution
            if self.ranges[3].count > 0 {
                var groupedvalues = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: self.ranges[1].count)
                
                //analyze the data
                for i in 0..<self.ranges[3].count {
                    let min = (self.ranges[3][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[3][i].0)
                    let max = (self.ranges[3][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[3][i].1)
                    
                    for j in 0..<local_id_id.count {
                        let value = Double((FlagForHbA1cTypes ? visits[j].hba1c_iffc : visits[j].hba1c_ngsp)!)
                        
                        if value > min && value <= max {
                            if let diabeteDurationInDays = patients[j].diabetes_duration_in_days {
                                for index in 0..<diabeteDurationRanges.count {
                                    if Double(diabeteDurationInDays) > diabeteDurationRanges[index].0 && Double(diabeteDurationInDays) <= diabeteDurationRanges[index].1{
                                        groupedvalues[index][i] += 1
                                    }
                                }
                            }
                        }
                    }
                }
                
                //setup the input for bar chart
                var titleForHbA1cRanges = [String]()
                for hba1cRange in self.ranges[3] {
                    let title: String = (hba1cRange.0 == Double.leastNormalMagnitude ? "" : hba1cRange.0.description) + "~" + (hba1cRange.1 == Double.greatestFiniteMagnitude ? "" : hba1cRange.1.description)
                    titleForHbA1cRanges.append(title)
                }
                
                //add bar chart for HbA1c duration distribution
                views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvalues, labels: titleForDiabeteDurationRanges,title:"HbA1c Range Distribution"))
            }
        }
        return views
    }
}
