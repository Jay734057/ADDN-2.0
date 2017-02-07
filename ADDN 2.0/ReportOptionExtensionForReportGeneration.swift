//
//  ReportOptionExtensionForReportGeneration.swift
//  ADDN 2.0
//
//  Created by Jay on 26/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Charts

extension ReportOptionController: ChartViewDelegate {
    
    func generateURLForPatientTable(local_id_id: [Int]) -> String {
        var urlForPatientTable = Constants.URL_PREFIX + "patient?order=local_id_id&select=gender,age_at_export_in_days,diabetes_duration_in_days,diabetes_type_other,diabetes_type_value,local_id_id&active=eq.true"
        
        if local_id_id.count > 0 {
            urlForPatientTable = urlForPatientTable + "&local_id_id=in."
            for id in local_id_id {
                urlForPatientTable = urlForPatientTable + id.description + ","
            }
            urlForPatientTable = urlForPatientTable.substring(to: urlForPatientTable.index(before: urlForPatientTable.endIndex))
        }
        
        if selectedAttributeIndexes[0].count == 1{
            urlForPatientTable = urlForPatientTable + "&gender=eq." + Constants.SELECTABLE_GENDERS[selectedAttributeIndexes[0][0]].uppercased()
        }
        
        if Constants.SELECTABLE_DIABETES_TYPES.endIndex != selectedAttributeIndexes[1][0]{
            urlForPatientTable = urlForPatientTable + "&diabetes_type_value=eq." + Constants.SELECTABLE_DIABETES_TYPES[selectedAttributeIndexes[1][0]].uppercased().replacingOccurrences(of: " ", with: "_")
        }else {
            urlForPatientTable = urlForPatientTable + "&diabetes_type_value=eq." + Constants.SELECTABLE_DIABETES_TYPES[Constants.SELECTABLE_DIABETES_TYPES.endIndex].uppercased()
        }
        
        if (switchForContact?.isOn)! {
            urlForPatientTable = urlForPatientTable + "&consent_to_be_contacted=eq.true"
        }
        
        print(urlForPatientTable)
        return urlForPatientTable
    }
    
    func generateURLForVisitTable() -> String {
        let urlForVisitTable = Constants.URL_PREFIX + "visit?order=local_id_id&select=hba1c_iffc,hba1c_ngsp,insulin_regimen,local_id_id&diagnosis_visit=eq.false&days_before_export=lte.365&hba1c_iffc=not.is.null"
        
        return urlForVisitTable
    }
    
    
    func fetchData() -> FetchedDataForReport {
        let fetchedData = FetchedDataForReport()
        
        APIservice.sharedInstance.fetchFromURLForVisit(url: generateURLForVisitTable()) { (visits: [Visit]) in
            for visit in visits {
                if let id = visit.local_id_id {
                    fetchedData.local_id_ids.append(Int(id))
                    fetchedData.visits.append(visit)
                }
            }
            
            APIservice.sharedInstance.fetchFromURLForPatient(url: self.generateURLForPatientTable(local_id_id: fetchedData.local_id_ids), completion: { (patients: [Patient]) in
                    fetchedData.local_id_ids = [Int]()
                for patient in patients {
                    if let id = patient.local_id_id {
                        fetchedData.local_id_ids.append(Int(id))
                        fetchedData.patients.append(patient)
                    }
                }
                
                fetchedData.visits = fetchedData.visits.filter({ fetchedData.local_id_ids.index(of: Int($0.local_id_id!)) != nil })
                
                self.showChart(fetchedData: fetchedData)
            })
            
            
        }
        
        return fetchedData
    }
    
        
    
    func showChart(fetchedData: FetchedDataForReport) {
        let report = ReportController()
        var views = [UIView]()
        
        let local_id_id = fetchedData.local_id_ids
        let patients = fetchedData.patients
        let visits = fetchedData.visits
        
        //gender
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
            
            views.append(PieChart(dataPoints: Constants.SELECTABLE_GENDERS, values: numbers, title: "Gender Distribution"))
            
//            for i in 0..<numbers.count {
//                print(totalAgesInDays[i]/365.0/numbers[i])
//                print(totalDurationsInDays[i]/365.0/numbers[i])
//                print(HbA1cRanges[i].average)
//                print(HbA1cRanges[i].median)
//                print(HbA1cRanges[i].min)
//                print(HbA1cRanges[i].max)
//            }
            
            //HbA1c Range
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
        }
    ///////////////////////////////////////////////////////////////////////////////////////////////
        //Age
        if self.ranges[0].count > 0 {
            if FlagForAgeBreakDown {
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
                
                var titleForAgeRanges = [String]()
                for range in self.ranges[0] {
                    let title: String = (range.0 == Double.leastNormalMagnitude ? "" : range.0.description) + "~" + (range.1 == Double.greatestFiniteMagnitude ? "" : range.1.description)
                    titleForAgeRanges.append(title)
                }
                
                views.append(BarChartWithFormatter(dataPoints: titleForAgeRanges, groupedValues: numbers, labels: Constants.SELECTABLE_GENDERS, title: "Age break down by genders"))
                
                            for i in 0..<numbers.count {
                                for j in 0..<numbers[i].count {
                                    print(totalAgesInDays[i][j]/365.0/numbers[i][j])
                                    print(totalDurationsInDays[i][j]/365.0/numbers[i][j])
                                    print(HbA1cRanges[i][j].average)
                                    print(HbA1cRanges[i][j].median)
                                    print(HbA1cRanges[i][j].min)
                                    print(HbA1cRanges[i][j].max)
                                }
                            }
                
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
                    
                    var titleForHbA1cRanges = [String]()
                    for hba1cRange in self.ranges[3] {
                        let datapoint: String = (hba1cRange.0 == Double.leastNormalMagnitude ? "" : hba1cRange.0.description) + "~" + (hba1cRange.1 == Double.greatestFiniteMagnitude ? "" : hba1cRange.1.description)
                        titleForHbA1cRanges.append(datapoint)
                    }
                    
                    
                    views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvalues, labels: titleForAgeRanges,title:"HbA1c Range Distribution"))
                    
                }

            }else {
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
                
                var titleForAgeRanges = [String]()
                for range in self.ranges[0] {
                    let title: String = (range.0 == Double.leastNormalMagnitude ? "" : range.0.description) + "~" + (range.1 == Double.greatestFiniteMagnitude ? "" : range.1.description) + " years old"
                    titleForAgeRanges.append(title)
                }
                
                views.append(PieChart(dataPoints: titleForAgeRanges, values: numbers, title: "Age Distribution"))
                
                
                
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
                    
                    var titleForHbA1cRanges = [String]()
                    for hba1cRange in self.ranges[3] {
                        let datapoint: String = (hba1cRange.0 == Double.leastNormalMagnitude ? "" : hba1cRange.0.description) + "~" + (hba1cRange.1 == Double.greatestFiniteMagnitude ? "" : hba1cRange.1.description)
                        titleForHbA1cRanges.append(datapoint)
                    }
                    
                    
                    views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvalues, labels: titleForAgeRanges,title:"HbA1c Range Distribution"))
                    
                }

            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////
//        Insulin Regimen
        if self.selectedAttributeIndexes[2].count == 0 || self.selectedAttributeIndexes[2].count == Constants.SELECTABLE_INSULIN_REGIMEN.count {
            
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
                
                views.append(BarChartWithFormatter(dataPoints: Constants.SELECTABLE_INSULIN_REGIMEN, groupedValues: numbers, labels: titleForAgeRanges, title: "Insulin Regimen break down"))
                
                for i in 0..<numbers.count {
                    for j in 0..<numbers[i].count {
                        print(totalAgesInDays[i][j]/365.0/numbers[i][j])
                        print(totalDurationsInDays[i][j]/365.0/numbers[i][j])
                        print(HbA1cRanges[i][j].average)
                        print(HbA1cRanges[i][j].median)
                        print(HbA1cRanges[i][j].min)
                        print(HbA1cRanges[i][j].max)
                    }
                }

                
                
                
                
                if self.ranges[3].count > 0 {
                    var groupedvalues = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: self.ranges[1].count)
                    
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
                    
                    
                    views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvalues, labels: Constants.SELECTABLE_INSULIN_REGIMEN,title:"HbA1c Range Distribution"))
                    
                }

            }else {
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
                
                views.append(PieChart(dataPoints: Constants.SELECTABLE_INSULIN_REGIMEN, values: numbers, title: "Insulin Regimen Distribution"))
                
                if self.ranges[3].count > 0 {
                    var groupedvalues = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: self.ranges[1].count)
                    
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
                    
                    
                    views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvalues, labels: Constants.SELECTABLE_INSULIN_REGIMEN,title:"HbA1c Range Distribution"))
                    
                }

            }
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //diabetes duration
        if self.ranges[1].count > 0 {
            var numbers = [Double](repeating: 0.0, count: self.ranges[1].count)
            var totalAgesInDays = [Double](repeating: 0.0, count: self.ranges[1].count)
            var totalDurationsInDays = [Double](repeating: 0.0, count: self.ranges[1].count)
            var HbA1cRanges = [[Double]](repeating: [], count:  self.ranges[1].count)
            
            var diabeteDurationRanges = [(Double,Double)]()
            
            //initial ageRanges
            for i in 0..<self.ranges[1].count {
                let min = (self.ranges[1][i].0 == Double.leastNormalMagnitude ? 0:self.ranges[1][i].0) * 365
                let max = (self.ranges[1][i].1 == Double.greatestFiniteMagnitude ? 200:self.ranges[1][i].1) * 365
                diabeteDurationRanges.append((min,max))
            }
            
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
            
            var titleForDiabeteDurationRanges = [String]()
            for range in self.ranges[1] {
                let title: String = (range.0 == Double.leastNormalMagnitude ? "" : range.0.description) + "~" + (range.1 == Double.greatestFiniteMagnitude ? "" : range.1.description) + " years"
                titleForDiabeteDurationRanges.append(title)
            }
            
            views.append(PieChart(dataPoints: titleForDiabeteDurationRanges, values: numbers, title: "Diabete Duration Distribution"))
            
            if self.ranges[3].count > 0 {
                var groupedvalues = [[Double]](repeating: [Double](repeating: 0.0, count: self.ranges[3].count), count: self.ranges[1].count)
                
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
                
                var titleForHbA1cRanges = [String]()
                for hba1cRange in self.ranges[3] {
                    let title: String = (hba1cRange.0 == Double.leastNormalMagnitude ? "" : hba1cRange.0.description) + "~" + (hba1cRange.1 == Double.greatestFiniteMagnitude ? "" : hba1cRange.1.description)
                    titleForHbA1cRanges.append(title)
                }
                
                
                views.append(BarChartWithFormatter(dataPoints: titleForHbA1cRanges, groupedValues: groupedvalues, labels: titleForDiabeteDurationRanges,title:"HbA1c Range Distribution"))
                
            }
            
        }

        report.views = views
        report.navTitle = Constants.SELECTABLE_DIABETES_TYPES[self.selectedAttributeIndexes[1][0]]
        self.navigationController?.pushViewController(report, animated: true)

    }
}











