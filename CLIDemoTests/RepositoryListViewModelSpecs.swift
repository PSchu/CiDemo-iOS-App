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
                    expect(viewModel.repositoryData.value).to(beEmpty())
                }
                it("after some time for a network Call contains data") {
                    let viewModel = RepositoryListViewModel(apiProvider: GitHubApiDelayedMockProvider())
                    expect(viewModel.repositoryData.value).toEventuallyNot(beEmpty(), timeout: 3)
                    expect(viewModel.repositoryData.value.count).toEventually(equal(self.testRepos.count), timeout: 3)
                }
            }
            context("can filter its data") {
                let viewModel = RepositoryListViewModel(apiProvider: GitHubApiImediateMockProvider())
                it("to only show not forked repositories") {
                    viewModel.setFilter(.notForked)
                    expect(viewModel.filteredData.value).toNot(beEmpty())
                    expect(viewModel.filteredData.value).toNot(containElementSatisfying({ $0.isFork }))
                }
                
                it("to only show repositories with Wiki's") {
                    viewModel.setFilter(.hasWiki)
                    expect(viewModel.filteredData.value).toNot(beEmpty())
                    expect(viewModel.filteredData.value).toNot(containElementSatisfying({ !$0.hasWiki }))
                }
                
                it("to only show repositories with Pages") {
                    viewModel.setFilter(.hasPages)
                    expect(viewModel.filteredData.value).toNot(beEmpty())
                    expect(viewModel.filteredData.value).toNot(containElementSatisfying({ !$0.hasPages }))
                }
                
                it("an reset it to show all") {
                    viewModel.setFilter(nil)
                    expect(viewModel.filteredData.value.count).to(equal(self.testRepos.count))
                }
            }
            context("can sort its data") {
                let viewModel = RepositoryListViewModel(apiProvider: GitHubApiImediateMockProvider())
                it("after the most starred") {
                    viewModel.setSortModus(.mostStared)
                    for (index, higherStarCountRep) in viewModel.sortedAndFilterdData.value.enumerated() {
                        for (secondIndex, lowerStarCountRep) in viewModel.sortedAndFilterdData.value.enumerated() where secondIndex < index {
                            expect(higherStarCountRep.numberOfStars).to(beGreaterThanOrEqualTo(lowerStarCountRep.numberOfStars))
                        }
                    }
                }
            }
        }
    }
}
