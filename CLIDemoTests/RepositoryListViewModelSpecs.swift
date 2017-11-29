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

class GitHubApiMockProvider:  MoyaProvider<GitHubApi> {
    init() {
        super.init(stubClosure: { _ in .delayed(seconds: 1) })
    }
}

class RepositoryListViewModelSpecs: QuickSpec {
    override func spec() {
        describe("A RepositoryListViewModel") {
            context("the Data Property") {
                it("starts with an empty Array") {
                    let viewModel = RepositoryListViewModel(apiProvider: GitHubApiMockProvider())
                    expect(viewModel.data.value).to(beEmpty())
                }
                it("after some time for a network Call it contains data") {
                    let viewModel = RepositoryListViewModel(apiProvider: GitHubApiMockProvider())
                    expect(viewModel.data.value).toEventuallyNot(beEmpty())
                }
            }
            
        }
    }
}
