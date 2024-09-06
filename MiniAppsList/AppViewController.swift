//
//  AppViewController.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 05.09.2024.
//

import UIKit

class AppViewController: UIViewController {

    let texts = ["njdhf", "JHBDKJHB", "jsjuu", "11111","vmv554","6v56","n56k56k","7654","2345","swer56t"]
    let label = UILabel()
    let button = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        view.addSubview(label)
        label.text = "TestText"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.addSubview(button)
        button.setTitle("tets tap", for: .normal)
        button.addTarget(self, action: #selector(changeLabel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor)
        ])
    }
    @objc func changeLabel() {
        label.text = texts.randomElement()
    }
}
