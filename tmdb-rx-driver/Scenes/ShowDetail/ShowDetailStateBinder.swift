//
//  ShowDetailStateBinder.swift
//  tmdb-rx-driver
//
//  Created by Стожок Артём on 08.02.2022.
//

import Foundation
import Nuke

final class ShowDetailStateBinder: ViewControllerBinder {
    unowned let viewController: ShowDetailViewController
    private let driver: ShowDetailDriving

    init(viewController: ShowDetailViewController,
         driver: ShowDetailDriving) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }

    func dispose() { }

    func bindLoaded() {
        viewController.statusBarStyle = .lightContent

        viewController.bag.insert(
            viewController.rx.viewWillAppear
                .bind(onNext: unowned(self, in: ShowDetailStateBinder.viewWillAppear)),
            driver.data
                .drive(onNext: unowned(self, in: ShowDetailStateBinder.configure))
        )
    }

    private func configure(_ data: ShowDetailData) {
        viewController.showName.text = data.name
    }

    private func viewWillAppear(_ animated: Bool) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
