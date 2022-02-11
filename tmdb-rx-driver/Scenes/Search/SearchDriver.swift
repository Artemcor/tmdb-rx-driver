//
//  SearchViewModel.swift
//  tmdb-mvvm-pure
//
//  Created by krawiecp-home on 29/01/2019.
//  Copyright © 2019 tailec. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import Foundation

protocol SearchDriving {
    var isSwitchHidden: Driver<Bool> { get }
    var isLoading: Driver<Bool> { get }
    var results: Driver<[SearchResultItem]> { get }
    var didSelect: Driver<SearchResultItem> { get }
    
    func search(_ query: String)
    func selectCategory(_ category: SearchResultItemType)
    func select(_ model: SearchResultItem)
}

final class SearchDriver: SearchDriving {
    private let activityIndicator = ActivityIndicator()
    
    private let isSwitchHiddenRelay = BehaviorRelay<Bool?>(value: nil)
    private let resultsRelay = BehaviorRelay<[SearchResultItem]?>(value: nil)
    private let didSelectRelay = BehaviorRelay<SearchResultItem?>(value: nil)
    
    private var searchBag = DisposeBag()
    private var selectedCategory: SearchResultItemType = .movies

    private let api: TMDBApiProvider
    
    var isSwitchHidden: Driver<Bool> { isSwitchHiddenRelay.unwrap().asDriver() }
    var isLoading: Driver<Bool> { activityIndicator.asDriver() }
    var results: Driver<[SearchResultItem]> { resultsRelay.unwrap().asDriver() }
    var didSelect: Driver<SearchResultItem> { didSelectRelay.unwrap().asDriver() }
    
    init(api: TMDBApiProvider) {
        self.api = api
    }
    
    func search(_ query: String) {
        searchBag = DisposeBag()
        
        let isValid = query.count >= 3
        
        isSwitchHiddenRelay.accept(isValid)
        
        guard isValid else {
            resultsRelay.accept([])
            return
        }

        let searchResult: Observable<[SearchResultItem]>

        searchResult = api.searchMoviesAndPersons(forQuery: query)
            .map( { (content: [Content]?) in
                var searchResultItems = [SearchResultItem]()
                let contents = content ?? []
                for content in contents {
                    switch content {
                    case .movie(let movie):
                        searchResultItems.append(SearchResultItem(movie: movie))
                    case .person(let person):
                        searchResultItems.append(SearchResultItem(person: person))
                    case .tv(_):
                        print("it is show")
                    }
                }
                return searchResultItems
            })

        searchResult
            .trackActivity(activityIndicator)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: resultsRelay.accept)
            .disposed(by: searchBag)
    }
    
    func selectCategory(_ category: SearchResultItemType) {
        selectedCategory = category
    }
    
    func select(_ model: SearchResultItem) {
        didSelectRelay.accept(model)
    }
}

extension SearchDriver: StaticFactory {
    enum Factory {
        static var `default`: SearchDriving {
            SearchDriver(api: TMDBApi.Factory.default)
        }
    }
}
