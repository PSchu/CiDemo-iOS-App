//
//  RepositoryListViewModelSpecs.swift
//  CLIDemoTests
//
//  Created by Peter Schumacher on 28.11.17.
//  Copyright © 2017 ImagineOn GmbH. All rights reserved.
//

import Quick
import Nimble
@testable import CLIDemo
import Moya
import ReactiveCocoa
import ReactiveSwift
import Result

class GitHubApiDelayedMockProvider:  MoyaProvider<GitHubApi> {
    init() {
        super.init(stubClosure: { _ in .delayed(seconds: 1) })
    }
}

class GitHubApiImediateMockProvider:  MoyaProvider<GitHubApi> {
    init() {
        super.init(stubClosure: { _ in .immediate })
    }
}

class RepositoryListViewModelSpecs: QuickSpec {
    override func spec() {
        describe("A RepositoryListViewModel") {
            context("the Data Property") {
                it("starts with an empty Array") {
                    let viewModel = RepositoryListViewModel(apiProvider: GitHubApiDelayedMockProvider())
                    expect(viewModel.data.value).to(beEmpty())
                }
                it("after some time for a network Call it contains data") {
                    let viewModel = RepositoryListViewModel(apiProvider: GitHubApiDelayedMockProvider())
                    expect(viewModel.data.value).toEventuallyNot(beEmpty(), timeout: 3)
                }
            }
            context("a filter can be set") {
                it("a filter to only show not forked repositories") {
                    let viewModel = RepositoryListViewModel(apiProvider: GitHubApiImediateMockProvider())
                    viewModel.setFilter(.notForked)
                    expect(viewModel.data.value).toNot(containElementSatisfying({ $0.isFork }))
                }
            }
        }
    }
}
