import Foundation

public protocol ViewConfiguration: AnyObject {
    func setupViews()
    func configureViews()
    func setupViewHierarchy()
    func setupConstraints()
}

extension ViewConfiguration {
    public func setupViews() {
        configureViews()
        setupViewHierarchy()
        setupConstraints()
    }
    
    public func configureViews() {}
    public func setupViewHierarchy() {}
    public func setupConstraints() {}
}
