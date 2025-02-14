//
//  APODSearchViewController.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//

import UIKit
import Combine

final class SearchAPODViewController: UIViewController {
    
    private let viewModel: SearchAPODViewModelProtocol
    private let contentView = APODSearchView()
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SearchAPODViewModelProtocol) {
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
        title = "Buscar APOD"
        setupBindings()
    }

    private func setupBindings() {
        contentView.searchButtonTapped
            .sink { [weak self] selectedDate in
                self?.viewModel.fetchAPOD(for: selectedDate)
            }
            .store(in: &cancellables)

        viewModel.apodPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] apod in
                self?.contentView.update(with: apod)
            }
            .store(in: &cancellables)
    }
}
