//
//  DatePicker.swift
//  RecordKeep
//
//  Created by Mohanasundaram on 23/11/19.
//  Copyright © 2019 Task. All rights reserved.
//

import UIKit

class DatePickerFormatter {
    
    static let sharedInstance = DatePickerFormatter()
    
    func getDatePicker(startDate: Date?, endDate: Date?, currentDate: Date?, style: UIDatePicker.Mode) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = startDate
        datePicker.maximumDate = endDate
        datePicker.setDate(currentDate!, animated: true)
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }
    
    func formatDate(inputDate: String, inputFormat: String, outputFormat: String) -> String {
        let inputFormatter = dateFormatter(dateFormat: inputFormat)
        let outputFormatter = dateFormatter(dateFormat: outputFormat)
        return outputFormatter.string(from: inputFormatter.date(from: inputDate)!)
    }
    
    func formatDate(inputDate: Date, outputFormat: String) -> String {
        let outputFormatter = dateFormatter(dateFormat: outputFormat)
        return outputFormatter.string(from: inputDate)
    }
    
    func dateFrom(input: String, inputFormat: String) -> Date {
        let formatter = dateFormatter(dateFormat: inputFormat)
        return formatter.date(from: input)!
    }
    
    func getTimeStamp(dateString: String, dateFormat: String) -> String {
        return String(dateFrom(input: dateString, inputFormat: dateFormat).timeIntervalSince1970)
    }
    
    func getDate(timeStamp: String) -> String {
        let date = Date(timeIntervalSince1970: Double(timeStamp)!)
        return formatDate(inputDate: date, outputFormat: Constants.DateFormat.FormatTwo)
    }
    
    private func dateFormatter(dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = dateFormat
        return formatter
    }
}
