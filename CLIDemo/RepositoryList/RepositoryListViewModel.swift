//
//  RepositoryListViewModel.swift
//  CLIDemo
//
//  Created by Peter Schumacher on 27.11.17.
//  Copyright © 2017 ImagineOn GmbH. All rights reserved.
//

import Foundation
import ReactiveSwift
import Moya
import Unbox
import Result

extension GHRepository: RepositoryCellData {}

enum RepositorySortModus {
    case mostStarred
    case mostWatched
    case mostForked
    
    func sortPredicate(_ lhs: GHRepository, _ rhs: GHRepository) -> Bool {
        switch self {
        case .mostForked:
            return lhs.numberOfForks > rhs.numberOfForks
        case .mostStarred:
            return lhs.numberOfStars > rhs.numberOfStars
        case .mostWatched:
            return lhs.numberOfWatchers > rhs.numberOfWatchers
        }
    }
    
    var title: String {
        switch self {
        case .mostForked:
            return "Most Forked"
        case .mostStarred:
            return "Most Starred"
        case .mostWatched:
            return "Most Wached"
        }
    }
}

enum RepositoryFilter {
    case notForked
    case hasWiki
    case hasPages
    
    func repConforms(_ rep: GHRepository) -> Bool {
        switch self {
        case .notForked:
            return !rep.isFork
        case .hasWiki:
            return rep.hasWiki
        case .hasPages:
            return rep.hasPages
        }
    }
    
    var title: String {
        switch self {
        case .notForked:
            return "Not a Fork"
        case .hasWiki:
            return "has a Wiki"
        case .hasPages:
            return "has Pages"
        }
    }
}

class RepositoryListViewModel {
    let apiProvider: MoyaProvider<GitHubApi>
    let username: String = "krzysztofzablocki"
    var filter: MutableProperty<RepositoryFilter?> = MutableProperty(nil)
    var sortModus: MutableProperty<RepositorySortModus?> = MutableProperty(nil)
    
    private lazy var dataSignalProducer: SignalProducer<[GHRepository], AnyError> = self.apiProvider.reactive
        .request(.repositories(.user(name: self.username)))
        .filterSuccessfulStatusAndRedirectCodes()
        .unbox(array: GHRepository.self)
    
    private(set) lazy var repositoryData: Property<[GHRepository]> = Property(initial: [], then:
        self.dataSignalProducer
            .flatMapError { _ -> SignalProducer<[GHRepository], NoError> in
                return SignalProducer.empty
            }
    )
    
    var filteredData: Property<[GHRepository]> {
        return repositoryData
            .combineLatest(with: filter)
            .map({ (reps, filter) -> [GHRepository] in
                guard let filter = filter else { return reps }
                return reps.filter(filter.repConforms)
            })
    }
    
    var sortedAndFilterdData: Property<[GHRepository]> {
        return filteredData
            .combineLatest(with: sortModus)
            .map({ (reps, sortModus) -> [GHRepository] in
                guard let sortModus = sortModus else { return reps }
                return reps.sorted(by: sortModus.sortPredicate)
            })
    }
    
    init(apiProvider: MoyaProvider<GitHubApi> = GitHubApiProvider()) {
        self.apiProvider = apiProvider
    }
}

extension RepositoryListViewModel: RepositoryListViewControllerViewModel {
    func setFilter(_ filter: RepositoryFilter?) {
        self.filter.value = filter
    }
    
    func setSortModus(_ sortModus: RepositorySortModus?) {
        self.sortModus.value = sortModus
    }
    
    var data: Property<[RepositoryCellData]> {
        return sortedAndFilterdData.map { $0 as [RepositoryCellData] }
    }
    
    var title: String {
        return "Repositories of: \(self.username)"
    }
}
