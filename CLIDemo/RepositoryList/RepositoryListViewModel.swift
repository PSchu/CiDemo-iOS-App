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

class RepositoryListViewModel {
    let apiProvider: MoyaProvider<GitHubApi>
    let username: String = "PSchu"
    
    private lazy var dataSignalProducer: SignalProducer<[GHRepository], AnyError> = self.apiProvider.reactive
        .request(.repositories(.user(name: self.username)))
        .filterSuccessfulStatusAndRedirectCodes()
        .unbox(array: GHRepository.self)
    
    private lazy var repositoryData: Property<[GHRepository]> = Property(initial: [], then:
        self.dataSignalProducer
            .flatMapError { _ -> SignalProducer<[GHRepository], NoError> in
                return SignalProducer.empty
            }
    )
    
    init(apiProvider: MoyaProvider<GitHubApi> = GitHubApiProvider()) {
        self.apiProvider = apiProvider
    }
}

extension RepositoryListViewModel: RepositoryListViewControllerViewModel {
    var title: String {
        return "Repositories of: \(self.username)"
    }
    var newDataSignal: Signal<Void, NoError> {
        return repositoryData.signal
            .skip { $0.isEmpty }
            .map { _ in () }
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return repositoryData.value.count
    }
    
    func data(for indexPath: IndexPath) -> RepositoryCellData {
        return repositoryData.value[indexPath.row]
    }
}
