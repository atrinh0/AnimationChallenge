//
//  SymbolModel.swift
//  animation
//
//  Created by An Trinh on 09/06/2022.
//

import SwiftUI

class SymbolModel {
    var symbols: [Symbol] = []

    init() {
        loadSymbols()
    }
}

extension SymbolModel {
    private func loadSymbols() {
        let symbolsStrings = symbolsFromFile(name: "Symbols")

        symbols = symbolsStrings.map {
            Symbol(name: $0)
        }
    }

    private func symbolsFromFile(name: String) -> [String] {
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: "txt"),
              let fileContents = try? String(contentsOf: fileURL) else {
                  return []
        }
        return fileContents.split(separator: "\n").compactMap { $0.isEmpty ? nil : String($0) }
    }
}
