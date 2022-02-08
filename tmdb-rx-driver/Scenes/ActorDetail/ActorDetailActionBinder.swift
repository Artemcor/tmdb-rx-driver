//
//  ActorDetailActionBinder.swift
//  tmdb-rx-driver
//
//  Created by Стожок Артём on 07.02.2022.
//

import Foundation

final class ActorDetailActionBinder: ViewControllerBinder {
    unowned let viewController: ActorDetailViewController
    private let driver: ActorDetailDriving

    init(viewController: ActorDetailViewController,
         driver: ActorDetailDriving) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }

    func dispose() { }

    func bindLoaded() {
        viewController.bag.insert(
            viewController.backButton.rx.tap
                .bind(onNext: driver.close)
        )
    }
}
