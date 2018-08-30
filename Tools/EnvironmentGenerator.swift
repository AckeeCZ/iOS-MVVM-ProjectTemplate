#!/usr/bin/env xcrun --sdk macosx swift

import Foundation

let baseURL = URL(fileURLWithPath: ProcessInfo.processInfo.environment["ACK_ENVIRONMENT_DIR"]!)
let sourceURL = URL(string: "Current/environment.plist", relativeTo: baseURL)!
let targetURL = URL(string: "Environment.swift", relativeTo: baseURL)!
let plistData = try! Data(contentsOf: sourceURL)
var xmlFormat = PropertyListSerialization.PropertyListFormat.xml
let dictionary = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &xmlFormat) as! [String: Any]
let spacer = "    "

var result = "// Automatically generated\n\n"
result += "import Foundation\n\n"

func handleItem(_ item: [String: Any], name: String, level: Int) {
    func addRow(_ row: String, level: Int) {
        for _ in 0..<level { result += spacer }
        result += row + "\n"
    }

    if name.isEmpty { return }

    let enumName = name.replacingOccurrences(of: "api", with: "API").enumerated().map { $0 == 0 ? String($1).uppercased() : String($1) }.joined()

    addRow("enum " + enumName + " {", level: level)

    item.forEach { key, value in
        switch value {
        case let string as String where URL(string: string) != nil && key.lowercased().hasSuffix("url"):
            addRow("static let " + key + " = URL(string: \"" + string + "\")!", level: level + 1)
        case let bool as Bool where key.hasPrefix("is"):
            addRow("static let " + key + " = " + (bool ? "true" : "false"), level: level + 1)
        case let string as String:
            addRow("static let " + key + " = \"" + string + "\"", level: level + 1)
        case let int as Int:
            addRow("static let " + key + " = " + String(int), level: level + 1)
        case let double as Double:
            addRow("static let " + key + " = " + String(double), level: level + 1)
        case let date as Date:
            addRow("static let " + key + " = Date(timeIntervalSince1970: " + String(date.timeIntervalSince1970) + ")", level: level + 1)
        case let data as Data:
            addRow("static let " + key + " = Data(base64Encoded: \"" + data.base64EncodedString() + "\")!", level: level + 1)
        case let dictionary as [String: Any]:
            handleItem(dictionary, name: key, level: level + 1)

        default:
            print("Unsupported type of \(value)")
            exit(1)
        }
    }

    addRow("}\n", level: level)
}

handleItem(dictionary, name: "Environment", level: 0)

try! result.write(to: targetURL, atomically: true, encoding: .utf8)
