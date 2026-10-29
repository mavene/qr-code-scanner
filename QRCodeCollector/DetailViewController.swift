//
//  DetailViewController.swift
//  QRCodeCollector
//
//  Created by Jerin Tan on 29/10/26.
//

import UIKit
import CoreImage.CIFilterBuiltins

class DetailViewController: UIViewController {

        
    private let qrContent: String
    
    // Storage for the date/time placeholder strings
    private let placeholderDateString: String
    private let placeholderTimeString: String
    
    private let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.magnificationFilter = .nearest
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 12
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.1
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 8
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hold another device to scan this code"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    init(qrContent: String, dateString: String = "2026-10-29", timeString: String = "10:30 AM") {
        self.qrContent = qrContent
        self.placeholderDateString = dateString
        self.placeholderTimeString = timeString
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Scan Again"
        
        setupNavigationBar()
        setupLayout()
        displayQRCode()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissSheet)
        )
    }
    
    private func setupLayout() {
        view.addSubview(qrImageView)
        view.addSubview(contentLabel)
        view.addSubview(instructionLabel)
        view.addSubview(historyLabel)
        
        NSLayoutConstraint.activate([
            qrImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            qrImageView.widthAnchor.constraint(equalToConstant: 220),
            qrImageView.heightAnchor.constraint(equalToConstant: 220),
            
            contentLabel.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // 10 points of spacing below the link
            instructionLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            historyLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 25),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            historyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func dismissSheet() {
        dismiss(animated: true, completion: nil)
    }
    
    private func displayQRCode() {
        contentLabel.text = qrContent
        
        historyLabel.text = "Scanned: \(placeholderDateString), \(placeholderTimeString)"
                
        
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(qrContent.utf8)
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                qrImageView.image = UIImage(cgImage: cgImage)
            }
        }
    }
}


#Preview {
    DetailViewController(qrContent: "www.google.com")
}
