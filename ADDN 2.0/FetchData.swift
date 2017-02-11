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
        
//        if selectedAttributeIndexes[0].count == 1{
//            urlForPatientTable = urlForPatientTable + "&gender=eq." + Constants.SELECTABLE_GENDERS[selectedAttributeIndexes[0][0]].uppercased()
//        }
        
        if Constants.SELECTABLE_DIABETES_TYPES.endIndex != selectedAttributeIndexes[1][0]{
            urlForPatientTable = urlForPatientTable + "&diabetes_type_value=eq." + Constants.SELECTABLE_DIABETES_TYPES[selectedAttributeIndexes[1][0]].uppercased().replacingOccurrences(of: " ", with: "_")
        }else {
            urlForPatientTable = urlForPatientTable + "&diabetes_type_value=eq." + Constants.SELECTABLE_DIABETES_TYPES[Constants.SELECTABLE_DIABETES_TYPES.endIndex].uppercased()
        }
        
        if (switchForContact?.isOn)! {
            urlForPatientTable = urlForPatientTable + "&consent_to_be_contacted=eq.true"
        }
    
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
        let reportTitles = ["Gender Report", "Age Report", "Insulin Regimen Report", "Diabetes Report"]
        var reports = [ReportController]()
        let chartsForReports = [generateReportForGender(fetchedData: fetchedData),generateReportForAge(fetchedData: fetchedData), generateReportForInsulinRegimen(fetchedData: fetchedData), generateReportForDiabetes(fetchedData: fetchedData)]
        
//        views += generateReportForGender(fetchedData: fetchedData)
//        views += generateReportForAge(fetchedData: fetchedData)
//        views += generateReportForInsulinRegimen(fetchedData: fetchedData)
//        views += generateReportForDiabetes(fetchedData: fetchedData)
        for i in 0..<reportTitles.count {
            if chartsForReports[i].count > 0 {
                let report = ReportController()
                report.views = chartsForReports[i]
                
                report.reportTitle = reportTitles[i]
                reports.append(report)
            }
        }
        
        let reportPage = ReportPageViewController()
        
        reportPage.reports = reports
        
        reportPage.navTitle = Constants.SELECTABLE_DIABETES_TYPES[self.selectedAttributeIndexes[1][0]]
        
        self.navigationController?.pushViewController(reportPage, animated: true)

    }
}











