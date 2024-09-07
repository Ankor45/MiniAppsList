//
//  PopUpViewController.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 04.09.2024.
//

import UIKit


class PopUpViewController: UIViewController {
    // MARK: - Properties
    private lazy var contentView = UIView()
    private lazy var popUpView = UIView()
    private lazy var closeButton = ExtendedHitButton(type: .close)
    weak var delegate: PopUpViewControllerDelegate?

    // MARK: - Init
    init(contentView: UIView) {
        super.init(nibName: nil, bundle: nil)
        self.contentView = contentView
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    //MARK: - Methods
    @objc func dismissPopUp() {
        delegate?.didUpdateContent(with: contentView)
        dismiss(animated: true)
    }
}
//MARK: - Setup Layout
extension PopUpViewController {
    private func setupLayout() {
        setupPopUpView()
        setupContentView()
        setUpCloseButton()
    }
    private func setupPopUpView() {
        view.addSubview(popUpView)
        popUpView.layer.cornerRadius = 10
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popUpView.topAnchor.constraint(equalTo: view.topAnchor),
            popUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            popUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    private func setupContentView() {
        popUpView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: popUpView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor)
        ])
    }
    private func setUpCloseButton() {
        popUpView.addSubview(closeButton)
        closeButton.extendSize = 30
        closeButton.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -10)
        ])
    }
}
