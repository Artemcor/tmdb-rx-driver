//
//  ShowDetailViewController.swift
//  tmdb-rx-driver
//
//  Created by Стожок Артём on 08.02.2022.
//

import UIKit
import RxSwift

final class ShowDetailViewController: DisposeViewController {

    @IBOutlet private(set) var showName: UILabel!
    @IBOutlet private(set) var backButton: UIButton!
}

extension ShowDetailViewController: StaticFactory {
    enum Factory {
        static func`default`(id: Int) -> ShowDetailViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
            let driver = ShowDetailDriver.Factory.default(id: id)
            let stateBinder = ShowDetailStateBinder(viewController: vc, driver: driver)
            let actionBinder = ShowDetailActionBinder(viewController: vc, driver: driver)
            let navigationBinder = NavigationPopBinder<ShowDetailViewController>.Factory
                .pop(viewController: vc, driver: driver.didClose)
            vc.bag.insert(
                stateBinder,
                actionBinder,
                navigationBinder
            )
            return vc
        }
    }
}
