//
//  ReportViewModel.swift
//  Ehelp
//
//  Created by Mohammed on 22/9/19.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import Foundation
import MapKit

struct ReportViewModel {
        
    private var report: Report = Report()

    mutating func addEmergency(type: Emergency){
        let emergency: String = type.rawValue
        report.emergencyType = emergency
    }
    
    mutating func addLocation(lat: Double, long: Double){
        report.latitude = lat
        report.longitude = long
    }
    
    mutating func addMessage(msg: String){
        report.message = msg
    }
    
    mutating func addDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy:HH:mm"
        report.setDate(date: formatter.string(from: date))
    }
    
    func getEmergency() -> String{
        return report.emergencyType
    }
    
    func getMessage() -> String{
        return report.message
    }
    
    func getDate() -> String {
        return report.date
    }
    
    func latitude()  -> Double{
        return report.latitude
    }
    
    func longitude() -> Double{
        return report.longitude
    }
}
