//
//  LoadingView.swift
//
//
//  Created by Wonwoo Choi on 5/7/24.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate final class LoadingView: UIView {
    private let indicator = UIActivityIndicatorView(style: .large)
    private let lock = NSRecursiveLock()
    private let disposeBag = DisposeBag()
    private let startCount$ = BehaviorRelay(value: 0)
    
    var didStartCountChanged: ((Int) -> Void)?
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        setUp()
        bind()
    }
    
    deinit {
        print("deinit LoadingView.")
    }
}

private extension LoadingView {
    func setUp() {
        backgroundColor = .black.withAlphaComponent(0.1)
        indicator.center = center
        addSubview(indicator)
    }
    
    func bind() {
        startCount$
            .subscribe(with: self, onNext: { owner, count in
                owner.didStartCountChanged?(count)
            })
            .disposed(by: disposeBag)
    }
}

private extension LoadingView {
    func increment() {
        lock.lock()
        startCount$.accept(startCount$.value + 1)
        lock.unlock()
    }
    
    func decrement() {
        lock.lock()
        startCount$.accept(startCount$.value - 1)
        lock.unlock()
    }
}

fileprivate extension LoadingView {
    func startAnimating() {
        indicator.startAnimating()
        increment()
    }
    
    func stopAnimating() {
        decrement()
    }
}

// MARK: - UIView

fileprivate var loadingViewKey = "com.vogo.loadingViewKey"

fileprivate extension UIView {
    private var cachedLoadingViews: NSMutableArray {
        if let loadingViews = objc_getAssociatedObject(self, &loadingViewKey) as? NSMutableArray {
            return loadingViews
        }
        else {
            let loadingViews = NSMutableArray()
            objc_setAssociatedObject(self, &loadingViewKey, loadingViews, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return loadingViews
        }
    }
    
    func cachedLoadingView() -> LoadingView? {
        return cachedLoadingViews.firstObject as? LoadingView
    }
    
    func removeCachedLoadingView(_ loadingView: LoadingView) {
        guard cachedLoadingViews.contains(loadingView)
        else { return }
        cachedLoadingViews.remove(loadingView)
    }
    
    private func createLoadingView() -> LoadingView {
        let loadingView = LoadingView()
        loadingView.didStartCountChanged = { [weak self, weak loadingView] count in
            guard count <= 0,
                  let loadingView
            else { return }
            
            self?.removeCachedLoadingView(loadingView)
            loadingView.removeFromSuperview()
        }
        
        cachedLoadingViews.add(loadingView)
        
        return loadingView
    }
}

public extension UIView {
    /// 로딩 화면 보이기.
    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            if let loadingView = self?.cachedLoadingView() {
                loadingView.startAnimating()
            }
            else if let loadingView = self?.createLoadingView() {
                self?.addSubview(loadingView)
                
                loadingView.startAnimating()
            }
        }
    }
    
    /// 로딩 화면 감추기.
    /// startLoading을 실행한 회수와 같아야 동작.
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            let loadingView = self?.cachedLoadingView()
            loadingView?.stopAnimating()
        }
    }
    
    /// 로딩 화면 감추기.
    /// startLoading을 실행한 회수와 상관 없이 즉시 동작.
    func forceStopLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let loadingView = self?.cachedLoadingView()
            else { return }
            
            self?.removeCachedLoadingView(loadingView)
            loadingView.removeFromSuperview()
        }
    }
}

public extension Reactive where Base: UIView {
    var isLoading: Binder<Bool> {
        return Binder(self.base) { view, isLoading in
            if isLoading {
                view.startLoading()
            } else {
                view.stopLoading()
            }
        }
    }
}
