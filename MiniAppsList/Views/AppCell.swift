//
//  AppCell.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 06.09.2024.
//

import UIKit

class AppCell: UITableViewCell {
    // MARK: - Properties
    let fullscreenButton = ExtendedHitButton(type: .close)
    let barrierView = UIView()
    var action: (() -> Void)?
    private var miniApp: UIViewController? {
        didSet {
            if let miniApp = miniApp {
                setupMiniAppView(with: miniApp)
                setupFullscreenButton()
                setupBarrierView()
            }
        }
    }
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    func configure(miniApp: UIViewController) {
        self.miniApp = miniApp
    }
    @objc private func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
}
//MARK: - Setup Layout
extension AppCell {
    private func setupContentView() {
        backgroundColor = .clear
    }
    private func setupMiniAppView(with miniApp: UIViewController) {
        contentView.addSubview(miniApp.view)
        miniApp.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            miniApp.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            miniApp.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            miniApp.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            miniApp.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    private func setupFullscreenButton() {
        contentView.addSubview(fullscreenButton)
        fullscreenButton.setImage(UIImage(systemName: "arrow.down.left.and.arrow.up.right"), for: .normal)
        fullscreenButton.extendSize = 30
        fullscreenButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        fullscreenButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fullscreenButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            fullscreenButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ])
    }
    private func setupBarrierView() {
        contentView.addSubview(barrierView)
        barrierView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barrierView.topAnchor.constraint(equalTo: contentView.topAnchor),
            barrierView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            barrierView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            barrierView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
