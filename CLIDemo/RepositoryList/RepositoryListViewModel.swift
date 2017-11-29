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

enum RepositoryFilter {
    case notForked
    
    func repConforms(_ rep: GHRepository) -> Bool {
        return !rep.isFork
    }
}

class RepositoryListViewModel {
    let apiProvider: MoyaProvider<GitHubApi>
    let username: String = "PSchu"
    var filter: MutableProperty<RepositoryFilter?> = MutableProperty(nil)
    
    private lazy var dataSignalProducer: SignalProducer<[GHRepository], AnyError> = self.apiProvider.reactive
        .request(.repositories(.user(name: self.username)))
        .filterSuccessfulStatusAndRedirectCodes()
        .unbox(array: GHRepository.self)
    
    private lazy var repositoryData: Property<[GHRepository]> = Property(initial: [], then:
        self.dataSignalProducer
            .flatMapError { _ -> SignalProducer<[GHRepository], NoError> in
                return SignalProducer.empty
            }
            .combineLatest(with: filter)
            .map({ (reps, filter) -> [GHRepository] in
                guard let filter = filter else { return reps }
                return reps.filter(filter.repConforms)
            })
    )
    
    init(apiProvider: MoyaProvider<GitHubApi> = GitHubApiProvider()) {
        self.apiProvider = apiProvider
    }
}

extension RepositoryListViewModel: RepositoryListViewControllerViewModel {
    func setFilter(_ filter: RepositoryFilter?) {
        self.filter.value = filter
    }
    
    var data: Property<[RepositoryCellData]> {
        return repositoryData.map { $0 as [RepositoryCellData] }
    }
    
    var title: String {
        return "Repositories of: \(self.username)"
    }
}
