//
//  AgeReportGeneration.swift
//  ADDN 2.0
//
//  Extension for generating the age report
//
//  Created by Jay on 10/02/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

extension ReportOptionController {
    func generateReportForAge(fetchedData: FetchedDataForDetailedReport) -> [UIView] {
        var views = [UIView]()
        
        //all retrieved data
        let local_id_id = fetchedData.local_id_ids
        let patients = fetchedData.patients
        let visits = fetchedData.visits

        //check the number of set age range
        if self.ranges[0].count > 0 {
            //age ranges exist
            if FlagForAgeBreakDown {
                //variables for storing analysis results
                var numbers = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[0].count), count: Constants.SELECTABLE_GENDERS.count)
                var totalAgesInDays = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[0].count), count: Constants.SELECTABLE_GENDERS.count)
                var totalDurationsInDays = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[0].count), count: Constants.SELECTABLE_GENDERS.count)
                var HbA1cRanges = [[[Double]]](repeating: [[Double]](repeating: [], count: self.ranges[0].count), count: Constants.SELECTABLE_GENDERS.count)
                var ageRanges = [(Double,Double)]()
                
                //initial ageRanges
                for i in 0..<self.ranges[0].count {
                    let min = (self.ranges[0][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[0][i].0) * 365
                    let max = (self.ranges[0][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[0][i].1) * 365
                    ageRanges.append((min,max))
                }
                
                //analyze the data
                for i in 0..<local_id_id.count {
                    for index in 0..<ageRanges.count {
                        if let ageInDays = patients[i].age_at_export_in_days {
                            if Double(ageInDays) > ageRanges[index].0 && Double(ageInDays) <= ageRanges[index].1 {
                                if let gender = patients[i].gender, let j = Constants.TITLES_FOR_GENDERS.index(of: gender){
                                    numbers[j][index] += 1
                                    totalAgesInDays[j][index] += Double(patients[i].age_at_export_in_days!)
                                    totalDurationsInDays[j][index] += Double(patients[i].diabetes_duration_in_days!)
                                    HbA1cRanges[j][index].append(Double(
                                        self.FlagForHbA1cTypes ? (visits[i].hba1c_iffc)! : (visits[i].hba1c_ngsp)!
                                    ))
                                }
                            }
                        }
                    }
                }
                
                //setup the input for the table or chart
                var titleForAgeRanges = [String]()
                
                for range in self.ranges[0] {
                    let title: String = (range.0 == Double.leastNormalMagnitude ? "" : range.0.description) + "~" + (range.1 == Double.greatestFiniteMagnitude ? "" : range.1.description)
                    titleForAgeRanges.append(title)
                }
                
                
                //add table for male to the report
                if self.selectedAttributeIndexes[0].index(of: 0) != nil || selectedAttributeIndexes[0].count == 0 {
                    var groupedValuesForMale = [[String]]()
                    for i in 0..<numbers[0].count {
                        groupedValuesForMale.append([numbers[0][i].description, String(format: "%.2f",(Double(totalAgesInDays[0][i])/Double(numbers[0][i])/365)),String(format: "%.2f",(Double(totalDurationsInDays[0][i])/Double(numbers[0][i])/365)),String(format: "%.2f",HbA1cRanges[0][i].average),HbA1cRanges[0][i].median.description + "0","\(HbA1cRanges[0][i].min)0~\(HbA1cRanges[0][i].max)0"])
                    }
                    
                    var maleTitlesForAges = [String]()
                    for title in titleForAgeRanges {
                        maleTitlesForAges.append("MALE: " + title)
                    }
                    
                    //add table for analysis result
                    views.append(Tabular(dataPoint: ["Total number", "Mean Age (years)","Mean Duration (years)","Mean HbA1c","Median HbA1c","HbA1c Range"], groupedvalues: groupedValuesForMale, titles: maleTitlesForAges))
                }
                
                //add table for female to the report
                if self.selectedAttributeIndexes[0].index(of: 1) != nil || selectedAttributeIndexes[0].count == 0 {
                    var groupedValuesForFeMale = [[String]]()
                    for i in 0..<numbers[1].count {
                        groupedValuesForFeMale.append([numbers[1][i].description, String(format: "%.2f",(Double(totalAgesInDays[1][i])/Double(numbers[1][i])/365)),String(format: "%.2f",(Double(totalDurationsInDays[1][i])/Double(numbers[1][i])/365)),String(format: "%.2f",HbA1cRanges[0][i].average),HbA1cRanges[1][i].median.description + "0","\(HbA1cRanges[1][i].min)0~\(HbA1cRanges[1][i].max)0"])
                    }
                    
                    var femaleTitlesForAges = [String]()
                    for title in titleForAgeRanges {
                        femaleTitlesForAges.append("FEMALE: " + title)
                    }
                    
                    //add table for analysis result
                    views.append(Tabular(dataPoint: ["Total number", "Mean Age (years)","Mean Duration (years)","Mean HbA1c","Median HbA1c","HbA1c Range"], groupedvalues: groupedValuesForFeMale, titles: femaleTitlesForAges))
                }
                
                let titleForBarChart = titleForAgeRanges
                
                //add bar chart for age breakdown result
                if self.selectedAttributeIndexes[0].count == 0 || self.selectedAttributeIndexes[0].count == Constants.SELECTABLE_GENDERS.count{
                    views.append(BarChartWithFormatter(dataPoints: titleForAgeRanges, groupedValues: numbers, labels: Constants.SELECTABLE_GENDERS, title: "Age break down by genders"))
                } else {
                    views.append(PieChart(dataPoints: titleForAgeRanges, values: numbers[self.selectedAttributeIndexes[0].first!], title: "Age break down by genders(" + Constants.SELECTABLE_GENDERS[self.selectedAttributeIndexes[0].first!] + ")"))
                }
                
                //if HbA1c ranges are set, generate the bar chart for HbA1c duration distribution
                if self.ranges[3].count > 0 {
                    
                    //variables for storing analysis result
                    var groupedvaluesForMale = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: self.ranges[0].count)
                    var groupedvaluesForFemale = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: self.ranges[0].count)
                    
                    //analyze the data
                    for i in 0..<self.ranges[3].count {
                        let min = (self.ranges[3][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[3][i].0)
                        let max = (self.ranges[3][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[3][i].1)
                        
                        for j in 0..<local_id_id.count {
                            let value = Double((FlagForHbA1cTypes ? visits[j].hba1c_iffc : visits[j].hba1c_ngsp)!)
                            
                            if value > min && value <= max {
                                if let ageInDays = patients[j].age_at_export_in_days {
                                    for index in 0..<ageRanges.count {
                                        if Double(ageInDays) > ageRanges[index].0 && Double(ageInDays) <= ageRanges[index].1{
                                            if patients[j].gender == Constants.TITLES_FOR_GENDERS[0]{
                                                groupedvaluesForMale[index][i] += 1
                                            }else {
                                                groupedvaluesForFemale[index][i] += 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    //setup the input for the bar chart
                    var titleForHbA1cRanges = [String]()
                    for hba1cRange in self.ranges[3] {
                        let datapoint: String = (hba1cRange.0 == Double.leastNormalMagnitude ? "" : hba1cRange.0.description) + "~" + (hba1cRange.1 == Double.greatestFiniteMagnitude ? "" : hba1cRange.1.description)
                        titleForHbA1cRanges.append(datapoint)
                    }
                    
                    //add bar chart for HbA1c duration to the report
                    if self.selectedAttributeIndexes[0].index(of: 0) != nil  || selectedAttributeIndexes[0].count == 0 {
                        views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvaluesForMale, labels: titleForBarChart,title:"HbA1c Range Distribution For Male"))
                    }
                    
                    if self.selectedAttributeIndexes[0].index(of: 1) != nil || selectedAttributeIndexes[0].count == 0 {
                        views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvaluesForFemale, labels: titleForBarChart,title:"HbA1c Range Distribution For Female"))
                        
                    }
                }
                
            }else {
                //no breakdown needed
                var numbers = [Double](repeating: 0.0, count: self.ranges[0].count)
                var totalAgesInDays = [Double](repeating: 0.0, count: self.ranges[0].count)
                var totalDurationsInDays = [Double](repeating: 0.0, count: self.ranges[0].count)
                var HbA1cRanges = [[Double]](repeating: [], count:  self.ranges[0].count)
                
                var ageRanges = [(Double,Double)]()
                
                //initial ageRanges
                for i in 0..<self.ranges[0].count {
                    let min = (self.ranges[0][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[0][i].0) * 365
                    let max = (self.ranges[0][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[0][i].1) * 365
                    ageRanges.append((min,max))
                }
                
                //analyze the data
                for i in 0..<local_id_id.count {
                    for index in 0..<ageRanges.count {
                        if let ageInDays = patients[i].age_at_export_in_days {
                            if Double(ageInDays) > ageRanges[index].0 && Double(ageInDays) <= ageRanges[index].1 {
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
                var titleForAgeRanges = [String]()
                for range in self.ranges[0] {
                    let title: String = (range.0 == Double.leastNormalMagnitude ? "" : range.0.description) + "~" + (range.1 == Double.greatestFiniteMagnitude ? "" : range.1.description) + " years old"
                    titleForAgeRanges.append(title)
                }
                
                //group the analysis results
                var groupedValues = [[String]]()
                for i in 0..<numbers.count {
                    groupedValues.append([numbers[i].description, String(format: "%.2f",(Double(totalAgesInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",(Double(totalDurationsInDays[i])/Double(numbers[i])/365)),String(format: "%.2f",HbA1cRanges[i].average),HbA1cRanges[i].median.description + "0","\(HbA1cRanges[i].min)0~\(HbA1cRanges[i].max)0"])
                }
                
                //add table for analysis result to the report
                views.append(Tabular(dataPoint: ["Total number", "Mean Age (years)","Mean Duration (years)","Mean HbA1c","Median HbA1c","HbA1c Range"], groupedvalues: groupedValues, titles: titleForAgeRanges))
                
                //add pie chart for age duration to the report
                views.append(PieChart(dataPoints: titleForAgeRanges, values: numbers, title: "Age Distribution"))
                
                //if HbA1c ranges are set, generate the bar chart for HbA1c duration distribution
                if self.ranges[3].count > 0 {
                    var groupedvalues = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: self.ranges[0].count)
                    
                    for i in 0..<self.ranges[3].count {
                        let min = (self.ranges[3][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[3][i].0)
                        let max = (self.ranges[3][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[3][i].1)
                        
                        for j in 0..<local_id_id.count {
                            let value = Double((FlagForHbA1cTypes ? visits[j].hba1c_iffc : visits[j].hba1c_ngsp)!)
                            
                            if value > min && value <= max {
                                if let ageInDays = patients[j].age_at_export_in_days {
                                    for index in 0..<ageRanges.count {
                                        if Double(ageInDays) > ageRanges[index].0 && Double(ageInDays) <= ageRanges[index].1{
                                            groupedvalues[index][i] += 1
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    //setup the input for tables and charts
                    var titleForHbA1cRanges = [String]()
                    for hba1cRange in self.ranges[3] {
                        let datapoint: String = (hba1cRange.0 == Double.leastNormalMagnitude ? "" : hba1cRange.0.description) + "~" + (hba1cRange.1 == Double.greatestFiniteMagnitude ? "" : hba1cRange.1.description)
                        titleForHbA1cRanges.append(datapoint)
                    }
                    
                    //add bar chart for HbA1c duration distribution to the report
                    views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvalues, labels: titleForAgeRanges,title:"HbA1c Range Distribution"))
                    
                }
                
            }
            
        }
        return views
    }
}

