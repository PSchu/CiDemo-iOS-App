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

class RepositoryListViewModel {
    let apiProvider: MoyaProvider<GitHubApi>
    
    lazy var dataSignal: SignalProducer<[GHRepository], AnyError> = self.apiProvider.reactive
        .request(.repositories(.user(name: "PSchu")))
        .filterSuccessfulStatusAndRedirectCodes()
        .unbox(array: GHRepository.self)
    
    init(apiProvider: MoyaProvider<GitHubApi> = GitHubApiProvider()) {
        self.apiProvider = apiProvider
    }
}

extension RepositoryListViewModel: RepositoryListViewControllerViewModel {}
