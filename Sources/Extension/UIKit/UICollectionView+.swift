//
//  UICollectionView+.swift
//
//
//  Created by Wonwoo Choi on 4/7/24.
//

import UIKit

// MARK: - Register

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: Identifiable {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: XibLoadable {
        register(T.nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind elementKind: String) where T: Identifiable {
        register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.identifier)
    }
    
    func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind elementKind: String) where T: XibLoadable {
        register(T.nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.identifier)
    }
}

// MARK: - Dequeue

public extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T where T: Identifiable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
        else { fatalError("'\(T.identifier)' dequeue failure.") }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UICollectionReusableView>(_: T.Type, ofKind elementKind: String, for indexPath: IndexPath) -> T where T: Identifiable {
        guard let headerFooterView = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.identifier, for: indexPath) as? T
        else { fatalError("'\(T.identifier)' dequeue failure.") }
        return headerFooterView
    }
}


