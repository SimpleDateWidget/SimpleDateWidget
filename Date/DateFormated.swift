//
//  DateFormated.swift
//  Date
//
//  Created by BAproductions on 2/23/22.
//

import Foundation

extension Date {
    func formatDT(format:String = "MMMM/dd/yyyy hh:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let formatedDate = formatter.string(from: self)
        return formatedDate
    }
}
