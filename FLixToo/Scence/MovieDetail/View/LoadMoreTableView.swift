//
//  LoadMoreTableView.swift
//  FLixToo
//
//  Created by buixuanhuy on 01/09/2024.
//

import RxCocoa
import RxSwift
import UIKit

class TableViewExtension: UITableView {
    override var contentSize: CGSize {
        didSet {
            didGetContentSize?(contentSize)
        }
    }
    
    var didGetContentSize: ((_ size: CGSize) -> Void)?
    
    func reloadData(_ completed: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0) {
            self.reloadData()
        } completion: { _ in
            completed()
        }
    }
}

extension UIActivityIndicatorView {
    func startLoading() {
        isHidden = false
        startAnimating()
    }

    func finishLoading() {
        isHidden = true
        stopAnimating()
    }
}

private struct Constant {
    static let heightOfFooterView: CGFloat = 40
}

private class LoadMoreView: UIView {
    private let activitiIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUpUI() {
        clipsToBounds = true
        backgroundColor = .clear
        activitiIndicator.style = .medium
        activitiIndicator.color = .gray
        activitiIndicator.stopAnimating()
        activitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activitiIndicator)
        activitiIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activitiIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func stopLoading() {
        activitiIndicator.stopAnimating()
        activitiIndicator.isHidden = true
    }

    func startLoading() {
        activitiIndicator.isHidden = false
        activitiIndicator.startLoading()
    }
}

class LoadMoreTableView: TableViewExtension {
    private var reloadControl = UIRefreshControl()
    private var disposeBag = DisposeBag()
    private var canLoadMore = true
    private var loadMoreView = LoadMoreView()

    var refreshTrigger: (() -> Void)?
    var loadMoreTrigger: (() -> Void)?

    var haveRefresh = true {
        didSet {
            setUpUI()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }

    private func setUpUI() {
        if haveRefresh {
            refreshControl = reloadControl
            reloadControl.rx
                .controlEvent(.valueChanged)
                .subscribe(onNext: { [weak self] _ in
                    self?.refreshTrigger?()
                })
                .disposed(by: disposeBag)
        } else {
            refreshControl = nil
        }
        loadMoreView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: Constant.heightOfFooterView)
        tableFooterView = loadMoreView
        rx.willDisplayCell
            .subscribe(onNext: { [weak self] _, indexPath in
                guard let self = self else {
                    return
                }
                var lastSectionHaveData = 0
                for i in (0 ..< self.numberOfSections).reversed() {
                    if self.numberOfRows(inSection: i) > 0 {
                        lastSectionHaveData = i
                        break
                    }
                }
                
                if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
                    if indexPath == lastVisibleIndexPath,
                       indexPath.section == lastSectionHaveData,
                        indexPath.row == self.numberOfRows(inSection: lastSectionHaveData) - 1,
                        self.convert(self.rectForRow(at: indexPath),
                                     to: self.superview).maxY > self.frame.maxY - 10 {
                        self.addLoading(indexPath) {
                            self.loadMoreTrigger?()
                        }
                    }
                }
            }).disposed(by: disposeBag)
        sizeFooterToFit(height: Constant.heightOfFooterView)
    }

    override func reloadData() {
        super.reloadData()
        refreshControl?.endRefreshing()
        loadMoreView.stopLoading()
    }

    func stopLoading() {
        refreshControl?.endRefreshing()
        loadMoreView.stopLoading()
    }

    private func addLoading(_: IndexPath, closure: @escaping (() -> Void)) {
        loadMoreView.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            closure()
        }
    }

    private func sizeFooterToFit(height: CGFloat) {
        if let footerView = tableFooterView {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            var frame = footerView.frame
            frame.size.height = height
            UIView.animate(withDuration: 0.3) {
                footerView.frame = frame
            }
            tableFooterView = footerView
        }
    }
}


