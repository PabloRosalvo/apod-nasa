import UIKit

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String { NSStringFromClass(self) }
}

public extension UITableView {
    func register<Cell>(_ cellType: Cell.Type) where Cell: UITableViewCell, Cell: Reusable {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    func registerHeaderFooter<Cell>(_ cellType: Cell.Type) where Cell: UITableViewHeaderFooterView, Cell: Reusable {
        register(cellType, forHeaderFooterViewReuseIdentifier: cellType.reuseIdentifier)
    }


    func dequeue<Cell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: UITableViewCell, Cell: Reusable {
        return dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell
            ?? Cell(style: .default, reuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeueHeaderFooter<Cell>(_ cellType: Cell.Type) -> Cell where Cell: UITableViewHeaderFooterView, Cell: Reusable {
        return dequeueReusableHeaderFooterView(withIdentifier: cellType.reuseIdentifier) as? Cell
            ?? Cell(reuseIdentifier: cellType.reuseIdentifier)
    }
}
