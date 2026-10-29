//
//  CodeCell.swift
//  QRCodeCollector
//
//  Created by Dian Maisara on 29/10/26.
//

import UIKit

final class QRCodeCell: UICollectionViewCell {
    static let identifier = "QRCodeCell"
    private let imageView = UIImageView()
    private let urlLabel = UILabel()
    private let dateLabel = UILabel()
    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.minimumContentSizeCategory = .small
        imageView.layer.magnificationFilter = .nearest
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        urlLabel.numberOfLines = 0
        urlLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        urlLabel.textAlignment = .center
        dateLabel.numberOfLines = 0
        dateLabel.font = .preferredFont(forTextStyle: .caption2)
        dateLabel.textAlignment = .center
        stack.axis = .vertical
        stack.alignment = .center
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(urlLabel)
        stack.addArrangedSubview(dateLabel)
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(with code: QRCode, style: LayoutStyle) {
        imageView.image = UIImage(systemName: "qrcode")
        urlLabel.text = code.imageURL
        dateLabel.text = UIHelper.formatDateTime(code.dateScanned)
    }
}
