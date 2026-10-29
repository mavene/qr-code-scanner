//
//  ViewController.swift
//  QRCodeCollector
//
//  Created by Dian Maisara on 29/10/26.
//

import UIKit

class ViewController: UIViewController {
    
    private let mockQRCodeData = "https://google.com"

    private let mockButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Mock Tap"
        config.image = UIImage(systemName: "qrcode.viewfinder")
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .medium
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
     
        
        setupLayout()
        setupAction()
    }
    
    private func setupLayout() {
        
        view.addSubview(mockButton)
        
        NSLayoutConstraint.activate([
            mockButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mockButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mockButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupAction() {
        mockButton.addTarget(self, action: #selector(mockButtonTapped), for: .touchUpInside)
    }

    @objc private func mockButtonTapped() {
        
        // Instantiate your separate detail view controller file
        let detailVC = DetailViewController(qrContent: mockQRCodeData)
        let navController = UINavigationController(rootViewController: detailVC)
        
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navController, animated: true, completion: nil)
    }
        
    
    
    
    
}


#Preview {
    ViewController()
}

