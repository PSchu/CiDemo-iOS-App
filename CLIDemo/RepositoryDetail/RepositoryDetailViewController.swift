//
//  RepositoryDetailViewController.swift
//  CLIDemo
//
//  Created by Peter Schumacher on 30.11.17.
//  Copyright © 2017 ImagineOn GmbH. All rights reserved.
//

import UIKit
import SnapKit

extension UILabel {
    convenience init(text: String, textStyle: UIFontTextStyle) {
        self.init()
        self.text = text
        self.font = .preferredFont(forTextStyle: textStyle)
        self.numberOfLines = 0
    }
}

class RepositoryDetailViewController: UIViewController {
    let model: GHRepository
    
    private(set) lazy var titleLabel: UILabel = UILabel(text: model.name, textStyle: .title1)
    private(set) lazy var descriptionLabel: UILabel = UILabel(text: model.description ?? "No description available", textStyle: .body)
    
    private(set) lazy var numberOfStarsLabel: UILabel = UILabel(text: "Number of Stars: \(model.numberOfStars)", textStyle: .body)
    private(set) lazy var numberOfForksLabel: UILabel = UILabel(text: "Number of Forks: \(model.numberOfForks)", textStyle: .body)
    private(set) lazy var numberOfWatchersLabel: UILabel = UILabel(text: "Number of Watchers: \(model.numberOfWatchers)", textStyle: .body)
    
    let stackView : UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    init(model: GHRepository) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        navigationController?.navigationBar.isTranslucent = false
        title = model.name
        view.backgroundColor = .white
        [titleLabel, descriptionLabel, numberOfStarsLabel, numberOfForksLabel, numberOfWatchersLabel].forEach(stackView.addArrangedSubview(_:))
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
