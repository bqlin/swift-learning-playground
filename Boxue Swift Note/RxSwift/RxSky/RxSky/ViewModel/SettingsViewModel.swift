//
// Created by Bq Lin on 2021/2/26.
// Copyright (c) 2021 Bq. All rights reserved.
//

import UIKit

class SettingsViewModel {
    struct Date: SettingViewModelProtocol {
        static let name = "Date format"
        static let count = DateMode.allCases.count

        let dateMode: DateMode
        var labelText: String {
            dateMode == .text ? "Fri, 01 December" : "F, 12/01"
        }

        var accessory: UITableViewCell.AccessoryType {
            UserDefaults.dateMode == dateMode ? .checkmark : .none
        }
    }

    struct Temperature: SettingViewModelProtocol {
        static let name = "Temperature unit"
        static let count = TemperatureMode.allCases.count

        let temperatureMode: TemperatureMode
        var labelText: String {
            temperatureMode == .celsius ? "Celsius" : "Fahrenheit"
        }
        var accessory: UITableViewCell.AccessoryType {
            UserDefaults.temperatureMode == temperatureMode ? .checkmark : .none
        }
    }

    static let section: [SettingViewModelProtocol.Type] = [Date.self, Temperature.self]
}

protocol SettingViewModelProtocol {
    static var name: String { get }
    static var count: Int { get }

    var labelText: String { get }
    var accessory: UITableViewCell.AccessoryType { get }
}