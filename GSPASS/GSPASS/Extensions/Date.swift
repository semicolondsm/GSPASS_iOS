//
//  Date.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/02.
//

import Foundation

extension Date {
    func dayBefore(day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -day, to: noon)!
    }
    func dayAfter(day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: +day, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter(day: 1).month != month
    }
}
