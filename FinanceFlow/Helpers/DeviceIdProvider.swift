//
//  DeviceIdProvider.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import UIKit

final class DeviceIdProvider {
    static func getDeviceId() -> String {
        guard let identifier = UIDevice.current.identifierForVendor else { return "" }
        return identifier.uuidString
    }
}
