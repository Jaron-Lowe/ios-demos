//
//  DateFormatter+Singleton.swift
//  DateFormatterTest
//
//  Created by Jaron Lowe on 3/30/21.
//

import Foundation

extension DateFormatter {
    static let shared: DateFormatter = {
        let formatter = DateFormatter();
        formatter.locale = Locale(identifier: "en_US");
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        return formatter;
    }()
}
