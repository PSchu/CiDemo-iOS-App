//
//  GitHubApi.swift
//  CLIDemo
//
//  Created by Peter Schumacher on 27.11.17.
//  Copyright © 2017 ImagineOn GmbH. All rights reserved.
//

import Foundation
import Moya

class GitHubApiProvider: MoyaProvider<GitHubApi> {

}

enum RepositoryHolder {
    case user(name: String)
    case organisation(name: String)
}

enum GitHubApi {
    case repositories(RepositoryHolder)
}

extension GitHubApi: TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    var path: String {
        switch self {
        case .repositories(let holder):
            switch holder {
            case .organisation(name: let name):
                return "/orgs/\(name)/repos"
            case .user(name: let name):
                return "/users/\(name)/repos"
            }

        }
    }
    var method: Moya.Method {
        switch self {
        case .repositories:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .repositories: // Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .repositories:
            return ReposEndpointSampleData.utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
