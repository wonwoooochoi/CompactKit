//
//  Loadable+.swift
//
//
//  Created by Wonwoo Choi on 4/7/24.
//

import UIKit

// MARK: - Identifiable

public protocol Identifiable {
    static var identifier: String { get }
}

public extension Identifiable where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

public extension Identifiable where Self: UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

public extension Identifiable where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

public extension Identifiable where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

// MARK: - StoryboardLoadable

public protocol StoryboardLoadable: Identifiable {
    static var storyboard: UIStoryboard { get }
}

public extension StoryboardLoadable {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: identifier, bundle: nil)
    }
}

public extension StoryboardLoadable where Self: UIViewController {
    static func instantiate() -> Self {
        guard let viewController = storyboard.instantiateViewController(identifier: identifier) as? Self
        else { fatalError("'\(identifier)' init failure.") }
        
        return viewController
    }
}

// MARK: - XibLoadable

public protocol XibLoadable: Identifiable {
    static var nib: UINib { get }
}

public extension XibLoadable {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

public extension XibLoadable where Self: UIView {
    static func instantiate() -> Self {
        guard let view = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first as? Self
        else { fatalError("'\(identifier)' init failure.") }
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        return view
    }
}

public extension UIView {
    func addSubview<T: UIView>(_: T.Type) where T: XibLoadable {
        let view = T.instantiate()
        view.frame = bounds
        
        addSubview(view)
    }
}
