//
//  ActorDetailDriver.swift
//  tmdb-rx-driver
//
//  Created by Стожок Артём on 07.02.2022.
//

import RxSwift
import RxCocoa

struct ActorDetailData {
    let name: String
}

extension ActorDetailData {
    init(actor: PersonNew) {
        self.name = actor.name
    }
}

protocol ActorDetailDriving {
    var data: Driver<ActorDetailData> { get }
    var didClose: Driver<Void> { get }

    func close()
}

final class ActorDetailDriver: ActorDetailDriving {
    private let closeRelay = PublishRelay<Void>()

    private let id: Int
    private let api: TMDBApiProvider

    var data: Driver<ActorDetailData> {
        api.fetchActorDetails(forPersonId: id)
            .unwrap()
            .compactMap(ActorDetailData.init)
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

extension ActorDetailDriver: StaticFactory {
    enum Factory {
        static func `default`(id: Int) -> ActorDetailDriving {
            ActorDetailDriver(id: id, api: TMDBApi.Factory.default)
        }
    }
}
