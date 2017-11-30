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
import Unbox

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
    let testRepos: [GHRepository] = {
        let testData = GitHubApi.repositories(.user(name: "")).sampleData
        do {
            return try unbox(data: testData)
        } catch let error {
            fatalError("Error occured while unboxing TestData: \(error)")
        }
    }()
    
    override func spec() {
        describe("A RepositoryListViewModel") {
            context("has a Data Property that ") {
                it("starts with an empty Array") {
                    let viewModel = RepositoryListViewModel(apiProvider: GitHubApiDelayedMockProvider())
                    expect(viewModel.data.value).to(beEmpty())
                }
                it("after some time for a network Call contains data") {
                    let viewModel = RepositoryListViewModel(apiProvider: GitHubApiDelayedMockProvider())
                    expect(viewModel.data.value).toEventuallyNot(beEmpty(), timeout: 3)
                    expect(viewModel.data.value.count).toEventually(equal(self.testRepos.count), timeout: 3)
                }
            }
            context("can filter its data") {
                let viewModel = RepositoryListViewModel(apiProvider: GitHubApiImediateMockProvider())
                it("to only show not forked repositories") {
                    viewModel.setFilter(.notForked)
                    expect(viewModel.data.value).toNot(beEmpty())
                    expect(viewModel.data.value).toNot(containElementSatisfying({ $0.isFork }))
                }
                
                it("to only show repositories with Wiki's") {
                    viewModel.setFilter(.hasWiki)
                    expect(viewModel.data.value).toNot(beEmpty())
                    expect(viewModel.data.value).toNot(containElementSatisfying({ !$0.hasWiki }))
                }
                
                it("to only show repositories with Pages") {
                    viewModel.setFilter(.hasPages)
                    expect(viewModel.data.value).toNot(beEmpty())
                    expect(viewModel.data.value).toNot(containElementSatisfying({ !$0.hasPages }))
                }
                
                it("an reset it to show all") {
                    viewModel.setFilter(nil)
                    expect(viewModel.data.value.count).to(equal(self.testRepos.count))
                }
            }
        }
    }
}
