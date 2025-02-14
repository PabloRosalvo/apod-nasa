//
//  FavoriteCell.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//

import UIKit
import Kingfisher
import WebKit

final class FavoriteCell: UITableViewCell, Reusable {
    
    private let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.isHidden = true
        webView.layer.cornerRadius = 10
        webView.clipsToBounds = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: FavoritesListModel) {
        titleLabel.text = model.title
        handleMediaLoading(urlString: model.mediaURL ?? "")
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.clipsToBounds = false
        
        contentView.addSubview(mediaImageView)
        contentView.addSubview(webView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            mediaImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mediaImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mediaImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mediaImageView.heightAnchor.constraint(equalToConstant: 200),
            
            webView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            webView.heightAnchor.constraint(equalToConstant: 200),

            titleLabel.topAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with apod: APODResponse) {
        titleLabel.text = apod.title
        handleMediaLoading(urlString: apod.url ?? "")
    }
    
    private func handleMediaLoading(urlString: String) {
        webView.isHidden = true
        mediaImageView.isHidden = true
        if urlString.contains("youtube.com/embed/") {
            webView.isHidden = false
            guard let url = URL(string: urlString) else { return }
            webView.load(URLRequest(url: url))
        } else {
            mediaImageView.isHidden = false
            mediaImageView.setImage(from: urlString)
        }
    }
}
