//
//  ViewController.swift
//  QRCodeCollector
//
//  Created by Dian Maisara on 29/10/26.
//

import UIKit

enum LayoutStyle {
    case grid, list
}

class ViewController: UIViewController {

    private var style: LayoutStyle = .grid
    private var codes = QRCodeStore.shared.load()
    
    
    private lazy var scanHandler = CameraScanHandler(presentingViewController: self)


    private let sideInset: CGFloat = 16
    private let spacing: CGFloat = 16

    private let segmented = UISegmentedControl(items: ["Grid", "List"])
    private let sizingCell = QRCodeCell(frame: .zero)   // used only to measure card heights

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 8, left: sideInset, bottom: 20, right: sideInset)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        
        scanHandler.delegate = self

        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Large title + Scan button
        title = "QR Codes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Scan", style: .plain, target: self, action: #selector(scanTapped))

        // Segmented control sits below the title, full width
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(layoutChanged), for: .valueChanged)
        segmented.translatesAutoresizingMaskIntoConstraints = false

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(QRCodeCell.self, forCellWithReuseIdentifier: QRCodeCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(segmented)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            segmented.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmented.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
            segmented.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset),

            collectionView.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func layoutChanged() {
        style = segmented.selectedSegmentIndex == 0 ? .grid : .list
        UIView.transition(with: collectionView, duration: 0.25, options: .transitionCrossDissolve) {
            self.collectionView.reloadData()
        }
    }

    @objc private func scanTapped() {
        scanHandler.launchCamera()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        codes.count
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: QRCodeCell.identifier, for: indexPath) as! QRCodeCell
        cell.configure(with: codes[indexPath.item], style: style)
        return cell
    }

    func collectionView(_ cv: UICollectionView, layout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let available = cv.bounds.width - sideInset * 2
        let width: CGFloat
        switch style {
        case .grid: width = floor((available - spacing) / 2)
        case .list: width = available
        }

        sizingCell.configure(with: codes[indexPath.item], style: style)
        let fitted = sizingCell.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        return CGSize(width: width, height: ceil(fitted.height))
    }

    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCode = codes[indexPath.item]
        
        // Instantiate your separate detail view controller file
        let detailVC = DetailViewController(qrContent: selectedCode)
       let navController = UINavigationController(rootViewController: detailVC)
       
       if let sheet = navController.sheetPresentationController {
           sheet.detents = [.medium(), .large()]
           sheet.prefersGrabberVisible = true
       }
       
       present(navController, animated: true, completion: nil)
    }
}


extension ViewController: CameraScanHandlerDelegate {
    func didCaptureQRCode(urlString: String) {
        // Pass the urlString along with the current timestamp (Date.now)
        let newCode = QRCode(imageURL: urlString, dateScanned: Date.now)
        
        // Add to active local code tracking list array
        self.codes.append(newCode)
        
        // Refresh collection layout view instantly
        self.collectionView.reloadData()
    }
}


#Preview {
    UINavigationController(rootViewController: ViewController())
}


