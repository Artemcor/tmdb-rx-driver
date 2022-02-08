//
//  ActorDetailViewController.swift
//  tmdb-rx-driver
//
//  Created by Стожок Артём on 06.02.2022.
//

import UIKit
import RxSwift

final class ActorDetailViewController: DisposeViewController {
    @IBOutlet private(set) var personName: UILabel!
    @IBOutlet private(set) var backButton: UIButton!
}

extension ActorDetailViewController: StaticFactory {
    enum Factory {
        static func`default`(id: Int) -> ActorDetailViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ActorDetailViewController") as! ActorDetailViewController
            let driver = ActorDetailDriver.Factory.default(id: id)
            let stateBinder = ActorDetailStateBinder(viewController: vc, driver: driver)
            let actionBinder = ActorDetailActionBinder(viewController: vc, driver: driver)
            let navigationBinder = NavigationPopBinder<ActorDetailViewController>.Factory
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

