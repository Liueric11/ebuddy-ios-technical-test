//
//  DateFormatter.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 23/12/24.
//

import Foundation

class FormatDate {
    static func dateFormatter(date: Date?) -> String {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        } else {
            return "N/A"
        }
    }
}
