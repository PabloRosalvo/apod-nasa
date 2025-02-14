//
//  FavoritesViewController.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//
import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    
    private let viewModel: FavoritesViewModelProtocol
    private let contentView = FavoritesView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favoritos"
        setupTableView()
        setupBindings()
        viewModel.loadFavorites()
    }
    
    private func setupTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

    private func setupBindings() {
        viewModel.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.contentView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFavorites().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteCell.self, for: indexPath)
        cell.configure(with: viewModel.getFavorites()[indexPath.row])
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Excluir") { [weak self] _, _, completionHandler in
            self?.viewModel.removeFavorite(at: indexPath.row)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
