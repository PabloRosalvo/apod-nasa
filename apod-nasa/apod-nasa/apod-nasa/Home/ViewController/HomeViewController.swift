import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModelProtocol
    private lazy var contentView: HomeView = HomeView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func loadView() {
        self.view = contentView
    }

    private func setupBindings() {
        viewModel.titleText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.contentView.titleText = title
            }
            .store(in: &cancellables)

        viewModel.descriptionText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] description in
                self?.contentView.descriptionText = description
            }
            .store(in: &cancellables)

        viewModel.imageUrlText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageUrl in
                self?.contentView.imageURLText = imageUrl
            }
            .store(in: &cancellables)
        
        contentView.actionButtonTapped
            .sink { [weak self] in
                self?.viewModel.primaryButtonTapped.send(())
            }
            .store(in: &cancellables)
    }
}
