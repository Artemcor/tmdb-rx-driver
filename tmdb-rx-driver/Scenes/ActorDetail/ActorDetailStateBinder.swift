//
//  ActorDetailStateBinder.swift
//  tmdb-rx-driver
//
//  Created by Стожок Артём on 07.02.2022.
//

import Foundation
import Nuke

final class ActorDetailStateBinder: ViewControllerBinder {
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
        viewController.statusBarStyle = .lightContent

        viewController.bag.insert(
            viewController.rx.viewWillAppear
                .bind(onNext: unowned(self, in: ActorDetailStateBinder.viewWillAppear)),
            driver.data
                .drive(onNext: unowned(self, in: ActorDetailStateBinder.configure))
        )
    }

    private func configure(_ data: ActorDetailData) {
        viewController.personName.text = data.name
    }

    private func viewWillAppear(_ animated: Bool) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
