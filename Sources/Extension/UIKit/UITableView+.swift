//
//  UITableView+.swift
//
//
//  Created by Wonwoo Choi on 4/7/24.
//

import UIKit


// MARK: - Register

public extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: Identifiable {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: XibLoadable {
        register(T.nib, forCellReuseIdentifier: T.identifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: Identifiable {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.identifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: XibLoadable {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.identifier)
    }
}

// MARK: - Dequeue

public extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type) -> T where T: Identifiable {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier) as? T
        else { fatalError("'\(T.identifier)' dequeue failure.") }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T where T: Identifiable {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
        else { fatalError("'\(T.identifier)' dequeue failure.") }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) -> T where T: Identifiable {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T
        else { fatalError("'\(T.identifier)' dequeue failure.") }
        return headerFooterView
    }
}
