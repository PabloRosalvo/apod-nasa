import UIKit
import Combine

final class FavoritesView: UIView {
    
    let tableView = UITableView()
    private var favorites: [FavoritesListModel] = []
    
    var deleteActionPublisher = PassthroughSubject<Int, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: String(describing: FavoriteCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func updateFavorites(_ favorites: [FavoritesListModel]) {
        self.favorites = favorites
        tableView.reloadData()
    }
}

extension FavoritesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoriteCell.self), for: indexPath) as! FavoriteCell
        cell.prepareForReuse()
        cell.configure(with: favorites[indexPath.row])
        return cell
    }
}

extension FavoritesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Excluir") { [weak self] _, _, completionHandler in
            self?.deleteActionPublisher.send(indexPath.row)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
