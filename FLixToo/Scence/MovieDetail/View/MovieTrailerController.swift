//
//  MovieTrailerController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 30/8/24.
//

import UIKit
import Reusable
import RxSwift
import YouTubePlayer

class MovieTrailerController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var repository = MovieRepository(APIService())
    var id: Int?
    var video = [MovieVideo]()
    var type = HomeCategoryOption.movie
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Videos"
        guard let id = id else { return }
        repository.getVideo(id: id, type: self.type).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            switch self?.type {
            case .movie:
                self?.video = results.filter { $0.typeVid == .trailer }
            default:
                self?.video = results
            }
            
            self?.tableView.reloadData()
            print("RESULT VID: \(self?.video.count)")
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.showCommonError(message: error.message ?? "")
            } else {
                self?.showCommonError(message: error.localizedDescription ?? "")
            }
        })
        .disposed(by: disposebag)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: MovieTrailerCell.self)
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension MovieTrailerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return video.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieTrailerCell.self)
        cell.setContentForCell(data: video[indexPath.row])
        return cell
    }
}

extension MovieTrailerController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayYoutubeController.instantiate()
        vc.key = video[indexPath.row].key ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieTrailerController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}


class PlayYoutubeController: BaseViewController {
    @IBOutlet weak var playerView: YouTubePlayerView!
    
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.loadVideoID(key)
    }
}

extension PlayYoutubeController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}
