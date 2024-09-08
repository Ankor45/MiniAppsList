//
//  BoardViewController.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 08.09.2024.
//

import UIKit

protocol BoardViewControllerDataSource: AnyObject {
    var currentGuesses: [[Character?]] { get }
    func boxColor(at indexPath: IndexPath) -> UIColor?
}

class BoardViewController: UIViewController {
    //MARK: - Properties
    weak var dataSource: BoardViewControllerDataSource?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
    }
    //MARK: - Setup Layout
    private func setupCollection() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    //MARK: - Methods
    public func reloadData() {
        collectionView.reloadData()
    }
}

//MARK: Collection View Delegates
extension BoardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.currentGuesses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let guesses = dataSource?.currentGuesses ?? []
        return guesses[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else { fatalError() }
        
        cell.backgroundColor = dataSource?.boxColor(at: indexPath)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        cell.label.font = .systemFont(ofSize: 22, weight: .medium)
        cell.label.textColor = dataSource?.boxColor(at: indexPath) != nil ? .white : .black
        
        let guesses = dataSource?.currentGuesses ?? []
        if let letter = guesses[indexPath.section][indexPath.row] {
            cell.configure(with: letter)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 30
        let size: CGFloat = (collectionView.frame.size.width - margin) / 5
        
        return CGSize(width: size, height: size * 1.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(
            top: 2,
            left: 2,
            bottom: 2,
            right: 2
        )
    }
}
