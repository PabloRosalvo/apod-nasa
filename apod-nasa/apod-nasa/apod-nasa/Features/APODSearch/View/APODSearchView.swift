import UIKit
import Combine
import WebKit

final class APODSearchView: UIView, ViewConfiguration {
    
    let searchButtonTapped = PassthroughSubject<String, Never>()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buscar APOD", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor.systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.isHidden = true
        webView.layer.cornerRadius = 12
        webView.clipsToBounds = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var mediaContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, mediaContainerView, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        backgroundColor = UIColor.systemBackground
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
    }
    
    func setupViewHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(datePicker)
        contentView.addSubview(searchButton)
        contentView.addSubview(stackView)
        mediaContainerView.addSubview(imageView)
        mediaContainerView.addSubview(webView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            datePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            searchButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 200),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            mediaContainerView.widthAnchor.constraint(equalToConstant: 300),
            mediaContainerView.heightAnchor.constraint(equalToConstant: 300),
            
            imageView.widthAnchor.constraint(equalTo: mediaContainerView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: mediaContainerView.heightAnchor),
            
            webView.widthAnchor.constraint(equalTo: mediaContainerView.widthAnchor),
            webView.heightAnchor.constraint(equalTo: mediaContainerView.heightAnchor)
        ])
    }
    
    @objc private func searchButtonAction() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = formatter.string(from: datePicker.date)
        searchButtonTapped.send(selectedDate)
    }
    
    func update(with apod: APODResponse?) {
        titleLabel.text = apod?.title
        descriptionLabel.text = apod?.explanation
        handleMediaLoading(urlString: apod?.url ?? "")
    }
    
    private func handleMediaLoading(urlString: String) {
        if urlString.contains("youtube.com/embed/") {
            webView.isHidden = false
            imageView.isHidden = true
            if let url = URL(string: urlString) {
                webView.load(URLRequest(url: url))
            }
        } else {
            webView.isHidden = true
            imageView.isHidden = false
            imageView.setImage(urlString)
        }
    }
}
