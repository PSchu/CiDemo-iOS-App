//
//  Repository.swift
//  CLIDemo
//
//  Created by Peter Schumacher on 27.11.17.
//  Copyright © 2017 ImagineOn GmbH. All rights reserved.
//

import Foundation
import Unbox

struct GHRepository: Unboxable {
    let id: Int
    let name: String
    let description: String?
    let isFork: Bool
    let hasWiki: Bool
    let hasPages: Bool
    let url: URL
    let numberOfStars: Int
    let numberOfForks: Int
    let numberOfWatchers: Int
    
    
    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
        description = try? unboxer.unbox(key: "description")
        isFork = try unboxer.unbox(key: "fork")
        hasWiki = try unboxer.unbox(key: "has_wiki")
        hasPages = try unboxer.unbox(key: "has_pages")
        url = try unboxer.unbox(key: "url")
        numberOfStars = try unboxer.unbox(key: "stargazers_count")
        numberOfForks = try unboxer.unbox(key: "forks_count")
        numberOfWatchers = try unboxer.unbox(key: "watchers_count")
    }
}
