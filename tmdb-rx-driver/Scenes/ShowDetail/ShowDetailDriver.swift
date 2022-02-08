//
//  ShowDetailDriver.swift
//  tmdb-rx-driver
//
//  Created by Стожок Артём on 08.02.2022.
//

import RxSwift
import RxCocoa

struct ShowDetailData {
    let name: String
}

extension ShowDetailData {
    init(show: Show) {
        self.name = show.name
    }
}

protocol ShowDetailDriving {
    var data: Driver<ShowDetailData> { get }
    var didClose: Driver<Void> { get }

    func close()
}

final class ShowDetailDriver: ShowDetailDriving {
    private let closeRelay = PublishRelay<Void>()

    private let id: Int
    private let api: TMDBApiProvider

    var data: Driver<ShowDetailData> {
        api.fetchShowDetails(forShowId: id)
            .unwrap()
            .compactMap(ShowDetailData.init)
            .asDriver()
    }

    var didClose: Driver<Void> { closeRelay.asDriver() }

    init(id: Int, api: TMDBApiProvider) {
        self.id = id
        self.api = api
    }

    func close() {
        closeRelay.accept(())
    }
}

extension ShowDetailDriver: StaticFactory {
    enum Factory {
        static func `default`(id: Int) -> ShowDetailDriving {
            ShowDetailDriver(id: id, api: TMDBApi.Factory.default)
        }
    }
}
