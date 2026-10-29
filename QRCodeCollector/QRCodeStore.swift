//
//  QRCodeStore.swift
//  QRCodeCollector
//
//  Created by Dian Maisara on 29/10/26.
//

import UIKit

// TODO: For now, just use the user defaults...
//class QRCodeStore {
//    static let shared = QRCodeStore()
//
//    private let fileURL = FileManager.default
//        .urls(for: .documentDirectory, in: .userDomainMask)[0]
//        .appendingPathComponent("codes.json")
//    private let seededKey = "hasSeededCodes"
//
//    func load() -> [QRCode] {
//        seedIfNeeded()
//        guard let data = try? Data(contentsOf: fileURL),
//              let codes = try? JSONDecoder().decode([QRCode].self, from: data) else { return [] }
//        return codes
//    }
//
//    func save(_ codes: [QRCode]) {
//        guard let data = try? JSONEncoder().encode(codes) else { return }
//        try? data.write(to: fileURL, options: .atomic)
//    }
//
//    private func seedIfNeeded() {
//        guard !UserDefaults.standard.bool(forKey: seededKey) else { return }
//        let seeds = [
//            QRCode(assetName: "testqr1", title: "Test QR 1"),
//            QRCode(assetName: "testqr2", title: "Test QR 2")
//        ].compactMap { $0 }
//        save(seeds)
//        UserDefaults.standard.set(true, forKey: seededKey)
//    }
//}

import UIKit

class QRCodeStore {
    static let shared = QRCodeStore()

    private let fileURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("codes.json")
    private let seededKey = "hasSeededCodes"

    func load() -> [QRCode] {
        seedIfNeeded()
        guard let data = try? Data(contentsOf: fileURL),
              let codes = try? JSONDecoder().decode([QRCode].self, from: data) else { return [] }
        return codes
    }

    func save(_ codes: [QRCode]) {
        guard let data = try? JSONEncoder().encode(codes) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    private func seedIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: seededKey) else { return }
        let seeds = [
            QRCode(assetName: "testqr1"),
            QRCode(assetName: "testqr2")
        ].compactMap { $0 }
        save(seeds)
        UserDefaults.standard.set(true, forKey: seededKey)
    }
}
