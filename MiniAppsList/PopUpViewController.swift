//
//  PopUpViewController.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 04.09.2024.
//

import UIKit


class PopUpViewController: UIViewController {
    // MARK: - Properties
    private lazy var popUpView = UIView()
    private lazy var closeButton = UIButton(type: .close)
    private lazy var fullscreenButton = UIButton(type: .close)
    private lazy var modalViewHeightConstraint = NSLayoutConstraint()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    //MARK: - Methods
    @objc func dismissPopUp() {
        dismiss(animated: true)
    }
    
    @objc func changeHeight() {
        let newHeight = modalViewHeightConstraint.constant == 280 ? self.view.frame.height : 280
        modalViewHeightConstraint.constant = newHeight
    }
}

//MARK: - Setup Layout
extension PopUpViewController {
    private func setupLayout() {
        setupPopUpView()
        setUpCloseButton()
        setUpFullscreenButton()
    }
    private func setupPopUpView() {
        view.addSubview(popUpView)
        popUpView.backgroundColor = .green
        popUpView.layer.cornerRadius = 10
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        modalViewHeightConstraint = popUpView.heightAnchor.constraint(equalToConstant: 280)
        
        NSLayoutConstraint.activate([
            popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popUpView.widthAnchor.constraint(equalTo: view.widthAnchor),
            modalViewHeightConstraint
        ])
    }
    private func setUpCloseButton() {
        popUpView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor, constant: -10)
        ])
    }
    private func setUpFullscreenButton() {
        popUpView.addSubview(fullscreenButton)
        fullscreenButton.setImage(UIImage(systemName: "rectangle.inset.fill"), for: .normal)
        fullscreenButton.addTarget(self, action: #selector(changeHeight), for: .touchUpInside)
        fullscreenButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fullscreenButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            fullscreenButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor)
        ])
    }
}
