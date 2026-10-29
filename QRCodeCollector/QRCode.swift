//
//  QRCode.swift
//  QRCodeCollector
//
//  Created by Dian Maisara on 29/10/26.
//

import Foundation
import UIKit

// MARK: QR Code data struct
//struct QRCode: Codable, Hashable {
//    let id: UUID
//    let content: String
//    let date: Date
//    
//    init(content: String) {
//        self.id = UUID(); self.content = content; self.date = Date()
//    }
//}

//struct QRCode: Codable, Hashable {
//    let id: UUID
//    let content: String
//    let imageFilename: String
//    let date: Date
//
//    var imageURL: URL { ImageStore.directory.appendingPathComponent(imageFilename) }
//    var image: UIImage? { UIImage(contentsOfFile: imageURL.path) }
//}


//struct QRCode: Codable {
//    let id: UUID
//    var title: String
//    let imageData: Data
//
//    var image: UIImage? { UIImage(data: imageData) }
//
//    init?(assetName: String, title: String) {
//        guard let png = UIImage(named: assetName)?.pngData() else { return nil }
//        self.id = UUID()
//        self.title = title
//        self.imageData = png
//    }
//}

import UIKit

struct QRCode: Codable {
    let id: UUID
    var imageURL: String
    var dateScanned: Date

    init(imageURL: String, dateScanned: Date) {
        self.id = UUID()
        self.imageURL = imageURL
        self.dateScanned = dateScanned
    }
}
