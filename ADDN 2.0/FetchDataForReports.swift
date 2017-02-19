//
//  FetchDataForReports.swift
//  ADDN 2.0
//
//  Created by Jay on 26/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Charts

extension ReportOptionController {
    
    func generateURLForPatientTable(local_id_id: [Int]) -> String {
        var urlForPatientTable = Constants.URL_PREFIX + "patient?order=local_id_id&select=gender,age_at_export_in_days,diabetes_duration_in_days,diabetes_type_other,diabetes_type_value,local_id_id&active=eq.true"
        
        //add local id constraints to the request url
        if local_id_id.count > 0 {
            urlForPatientTable = urlForPatientTable + "&local_id_id=in."
            for id in local_id_id {
                urlForPatientTable = urlForPatientTable + id.description + ","
            }
            urlForPatientTable = urlForPatientTable.substring(to: urlForPatientTable.index(before: urlForPatientTable.endIndex))
        }
        
        //add diabetes type constraints to the request url
        if Constants.SELECTABLE_DIABETES_TYPES.endIndex != selectedAttributeIndexes[1][0]{
            urlForPatientTable = urlForPatientTable + "&diabetes_type_value=eq." + Constants.SELECTABLE_DIABETES_TYPES[selectedAttributeIndexes[1][0]].uppercased().replacingOccurrences(of: " ", with: "_")
        }else {
            urlForPatientTable = urlForPatientTable + "&diabetes_type_value=eq." + Constants.SELECTABLE_DIABETES_TYPES[Constants.SELECTABLE_DIABETES_TYPES.endIndex].uppercased()
        }
        
        //add patient constraints to the request url
        if (switchForContact?.isOn)! {
            urlForPatientTable = urlForPatientTable + "&consent_to_be_contacted=eq.true"
        }
    
        return urlForPatientTable
    }
    
    func generateURLForVisitTable() -> String {
        let urlForVisitTable = Constants.URL_PREFIX + "visit?order=local_id_id&select=hba1c_iffc,hba1c_ngsp,insulin_regimen,local_id_id&diagnosis_visit=eq.false&days_before_export=lte.365&hba1c_iffc=not.is.null"
        return urlForVisitTable
    }
    
    
    func fetchDataForDetailedReport() -> FetchedDataForReport {
        let fetchedData = FetchedDataForReport()
        
        //retrieve data from visit table
        APIservice.sharedInstance.fetchFromURLForVisit(url: generateURLForVisitTable()) { (visits: [Visit]) in
            for visit in visits {
                if let id = visit.local_id_id {
                    fetchedData.local_id_ids.append(Int(id))
                    fetchedData.visits.append(visit)
                }
            }
            
            //retrieve data from patient table
            APIservice.sharedInstance.fetchFromURLForPatient(url: self.generateURLForPatientTable(local_id_id: fetchedData.local_id_ids), completion: { (patients: [Patient]) in
                    fetchedData.local_id_ids = [Int]()
                for patient in patients {
                    if let id = patient.local_id_id {
                        fetchedData.local_id_ids.append(Int(id))
                        fetchedData.patients.append(patient)
                    }
                }
                
                fetchedData.visits = fetchedData.visits.filter({ fetchedData.local_id_ids.index(of: Int($0.local_id_id!)) != nil })
                
                self.showDetailedReport(fetchedData: fetchedData)
            })

        }
        
        return fetchedData
    }
    
    func showDetailedReport(fetchedData: FetchedDataForReport) {
        //generate detailed reports
        let reportTitles = ["Gender Report", "Age Report", "Insulin Regimen Report", "Diabetes Report"]
        var reports = [ReportController]()
        let chartsForReports = [generateReportForGender(fetchedData: fetchedData),generateReportForAge(fetchedData: fetchedData), generateReportForInsulinRegimen(fetchedData: fetchedData), generateReportForDiabetes(fetchedData: fetchedData)]
        //setup the titles for each report
        for i in 0..<reportTitles.count {
            if chartsForReports[i].count > 0 {
                let report = ReportController()
                report.views = chartsForReports[i]
                report.reportTitle = reportTitles[i]
                reports.append(report)
            }
        }
        //setup report page controller
        let reportPage = ReportPageViewController()
        reportPage.reports = reports
        reportPage.navTitle = Constants.SELECTABLE_DIABETES_TYPES[self.selectedAttributeIndexes[1][0]]
        //present the detailed report
        self.navigationController?.pushViewController(reportPage, animated: true)

    }
}











