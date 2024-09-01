//
//  CommentViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 01/09/2024.
//

import UIKit
import Reusable
import RxSwift

class CommentViewController: BaseViewController {

    @IBOutlet weak var tableView: LoadMoreTableView!
    var repository = MovieRepository(APIService())
    private let disposebag = DisposeBag()
    var comment = [Comment]()
    var id: Int?
    var currentPage = 1
    var type = HomeCategoryOption.movie
    var lastPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Reviews"
        tableView.register(cellType: CommentCell.self)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.loadMoreTrigger = { [weak self] in
            self?.loadComment()
        }
        loadComment()
    }
    
    func loadComment() {
        guard let id = id, !lastPage else {
            tableView.stopLoading()
            return
        }
        repository.getReview(id: id, page: currentPage, checking: .unchecked, type: type).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            if results.isEmpty {
                self?.lastPage = true
                self?.tableView.stopLoading()
                return
            }
            self?.currentPage += 1
            self?.comment.append(contentsOf: results)
            self?.tableView.reloadData()
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.showCommonError(message: error.message ?? "")
            } else {
                self?.showCommonError(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
    }
}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CommentCell.self)
        cell.setContentForCell(comment: comment[indexPath.row], showSeparaterView: indexPath.row + 1 != comment.count)
        return cell
    }
}

extension CommentViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}
