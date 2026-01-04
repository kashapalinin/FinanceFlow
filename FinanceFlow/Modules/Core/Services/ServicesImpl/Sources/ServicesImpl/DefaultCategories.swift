//
//  DefaultCategories.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 02.01.2026.
//
import UIKit
import Domain

final class DefaultCategories {
    nonisolated(unsafe) static let expenses: [TransactionCategory] = [
        .init(id: UUID(), name: "Продукты", type: .EXPENSE, icon: UIImage(systemName: "cart")?.pngData() ?? Data(), color: UIColor.systemRed.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Транспорт", type: .EXPENSE, icon: UIImage(systemName: "bus")?.pngData() ?? Data(), color: UIColor.systemOrange.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Кафе", type: .EXPENSE, icon: UIImage(systemName: "cup.and.saucer")?.pngData() ?? Data(), color: UIColor.systemPink.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "ЖКХ", type: .EXPENSE, icon: UIImage(systemName: "house")?.pngData() ?? Data(), color: UIColor.systemGreen.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Развлечения", type: .EXPENSE, icon: UIImage(systemName: "gamecontroller")?.pngData() ?? Data(), color: UIColor.systemPurple.toHex()?.data(using: .utf8) ?? Data())
    ]

    nonisolated(unsafe) static let incomes: [TransactionCategory] = [
        .init(id: UUID(), name: "Зарплата", type: .INCOME, icon: UIImage(systemName: "banknote")?.pngData() ?? Data(), color: UIColor.systemBlue.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Подарок", type: .INCOME, icon: UIImage(systemName: "gift")?.pngData() ?? Data(), color: UIColor.systemTeal.toHex()?.data(using: .utf8) ?? Data()),
        .init(id: UUID(), name: "Доход", type: .INCOME, icon: UIImage(systemName: "arrow.up.circle")?.pngData() ?? Data(), color: UIColor.systemGreen.toHex()?.data(using: .utf8) ?? Data())
    ]
}

extension UIColor {
    public convenience init?(hexData: Data) {
        guard let hexString = String(data: hexData, encoding: .utf8) else {
            return nil
        }
        self.init(hexString: hexString)
    }
    
    public convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let length = hexSanitized.count
        
        if length == 6 {
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                alpha: 1.0
            )
        } else if length == 8 {
            self.init(
                red: CGFloat((rgb & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgb & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgb & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgb & 0x000000FF) / 255.0
            )
        } else {
            return nil
        }
    }
    
    public func toHex() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        let r = Int(round(red * 255))
        let g = Int(round(green * 255))
        let b = Int(round(blue * 255))
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

