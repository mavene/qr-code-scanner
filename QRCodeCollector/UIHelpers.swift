//
//  UIHelpers.swift
//  QRCodeCollector
//
//  Created by Dian Maisara on 29/10/26.
//

import Foundation

struct UIHelper {
    private static let standardDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy, HH:mm"
        return formatter
    }()
    
    // convert to "dd/mm/yyyy, hh:mm" 
    static func formatDateTime(_ date: Date) -> String {
        return standardDateFormatter.string(from: date)
    }
}
