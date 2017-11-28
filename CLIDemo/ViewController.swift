//
//  ViewController.swift
//  CLIDemo
//
//  Created by Peter Schumacher on 27.11.17.
//  Copyright © 2017 ImagineOn GmbH. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    let apiProvider = GitHubApiProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        apiProvider.request(.repositories(.user(name: "pschu"))) { (response) in
            switch response {
            case .failure(let error):
                print("\(error)")
            case .success(let response):
                print("\(String(data: response.data, encoding: .utf8) ?? "No Data")")
            }
        }
    }

}

