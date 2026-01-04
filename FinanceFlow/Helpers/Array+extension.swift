//
//  Array+extensio.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 02.01.2026.
//
import UIKit
import Domain

extension Array where Element == TransactionCategory {
    @MainActor static let expenses: [TransactionCategory] = [
        .init(id: UUID(), name: "Продукты", type: .EXPENSE, icon: UIImage(systemName: "cart")?.pngData() ?? Data(), color: UIColor.systemRed.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Транспорт", type: .EXPENSE, icon: UIImage(systemName: "bus")?.pngData() ?? Data(), color: UIColor.systemOrange.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Кафе", type: .EXPENSE, icon: UIImage(systemName: "cup.and.saucer")?.pngData() ?? Data(), color: UIColor.systemPink.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "ЖКХ", type: .EXPENSE, icon: UIImage(systemName: "house")?.pngData() ?? Data(), color: UIColor.systemGreen.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Развлечения", type: .EXPENSE, icon: UIImage(systemName: "gamecontroller")?.pngData() ?? Data(), color: UIColor.systemPurple.toHex()?.data(using: .utf8) ?? Data())
    ]

    @MainActor static let incomes: [TransactionCategory] = [
        .init(id: UUID(), name: "Зарплата", type: .INCOME, icon: UIImage(systemName: "banknote")?.pngData() ?? Data(), color: UIColor.systemBlue.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Подарок", type: .INCOME, icon: UIImage(systemName: "gift")?.pngData() ?? Data(), color: UIColor.systemTeal.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Доход", type: .INCOME, icon: UIImage(systemName: "arrow.up.circle")?.pngData() ?? Data(), color: UIColor.systemGreen.toHex()?.data(using: .utf8) ?? Data())
    ]
}


