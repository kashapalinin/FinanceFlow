//
//  TransactionsByCategory.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 04.01.2026.
//
import Foundation
import Domain

struct TransactionsByCategory {
    let id = UUID()
    let category: TransactionCategory
    let amount: Double
}
