//
//  Date+extension.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 02.01.2026.
//
import Foundation

extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func weekInterval() -> DateInterval {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        guard let startOfWeek = calendar.date(from: components) else {
            return DateInterval(start: self.startOfDay(), duration: 86400 * 7)
        }
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        return DateInterval(start: startOfWeek.startOfDay(), end: endOfWeek.startOfDay().addingTimeInterval(86399))
    }
    
    func monthInterval() -> DateInterval {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        guard let startOfMonth = calendar.date(from: components) else {
            return DateInterval(start: self.startOfDay(), duration: 86400 * 30)
        }
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        let end = endOfMonth.addingTimeInterval(-1)
        return DateInterval(start: startOfMonth.startOfDay(), end: end.startOfDay().addingTimeInterval(86399))
    }
    
    func yearInterval() -> DateInterval {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        guard let startOfYear = calendar.date(from: components) else {
            return DateInterval(start: self.startOfDay(), duration: 86400 * 365)
        }
        let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
        let end = endOfYear.addingTimeInterval(-1)
        return DateInterval(start: startOfYear.startOfDay(), end: end.startOfDay().addingTimeInterval(86399))
    }
}
