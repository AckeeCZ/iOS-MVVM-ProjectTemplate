#!/usr/bin/env swift

import Foundation

func rename(with name: String) throws {
    try replaceName(at: "Podfile", name: name)
    try replaceName(at: "Project.swift", name: name)
    try replaceName(at: "Setup.swift", name: name)
    try replaceName(at: "Workspace.swift", name: name)
    try replaceName(at: ".swiftlint.yml", name: name)
    
    try FileManager.default.moveItem(atPath: "ProjectTemplate", toPath: name)
}

func replaceName(at path: String, name: String) throws {
    let content = try String(contentsOfFile: path)
    try content.replacingOccurrences(of: "ProjectTemplate", with: name).write(toFile: path, atomically: true, encoding: .utf8)
}

let arguments = CommandLine.arguments
if arguments.count == 2 {
    try rename(with: arguments[1])
} else {
    print("You must provide a name argument")
}

try FileManager.default.removeItem(atPath: "rename.swift")
