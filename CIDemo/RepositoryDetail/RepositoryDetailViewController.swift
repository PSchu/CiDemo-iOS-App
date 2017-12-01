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
    convenience init(text: String, textStyle: UIFontTextStyle = .body) {
        self.init()
        self.text = text
        self.font = .preferredFont(forTextStyle: textStyle)
        self.numberOfLines = 0
    }
}

class RepositoryDetailViewController: UIViewController {
    let model: GHRepository

    private(set) lazy var titleLabel: UILabel = UILabel(text: model.name, textStyle: .title1)
    private(set) lazy var descriptionLabel: UILabel = UILabel(text: model.description ?? "No description available")

    private(set) lazy var numOfStarsLabel: UILabel = UILabel(text: "Number of Stars: \(model.numberOfStars)")
    private(set) lazy var numOfForksLabel: UILabel = UILabel(text: "Number of Forks: \(model.numberOfForks)")
    private(set) lazy var numOfWatchersLabel: UILabel = UILabel(text: "Number of Watchers: \(model.numberOfWatchers)")

    let stackView: UIStackView = {
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
        [titleLabel, descriptionLabel, numOfStarsLabel, numOfForksLabel, numOfWatchersLabel]
            .forEach(stackView.addArrangedSubview(_:))
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalTo(view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
