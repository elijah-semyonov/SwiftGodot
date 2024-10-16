//
//  Printer.swift
//  Generator
//
//  Created by Miguel de Icaza on 4/19/23.
//

import Foundation
import Utilities

extension Printer {
    func save (_ file: String) {
        if let existing = try? String (contentsOfFile: file) {
            if existing == result {
                return
            }
        }
        try! result.write(toFile: file, atomically: false, encoding: .utf8)
    }
}

actor PrinterFactory {
    static let shared = PrinterFactory()
    
    private var printers: [Printer] = []
    
    func initPrinter(_ name: String) -> Printer {
        let printer = Printer(name: name)
        printers.append(printer)
        return printer
    }
    
    func save (_ file: String) {
        let result = printers.sorted(by: { $0.name < $1.name }).map({ $0.result }).joined(separator: "\n")
        if let existingData = try? Data(url: URL(fileURLWithPath: file)), let existing = String(data: existingData, encoding: .utf8) {
            if existing == result {
                return
            }
        }
        try! result.write(toFile: file, atomically: false, encoding: .utf8)
    }
}
