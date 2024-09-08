//
//  KeyboardViewController.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 08.09.2024.
//

import UIKit

protocol KeyboardViewControllerDelegate: AnyObject {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character)
}

class KeyboardViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: KeyboardViewControllerDelegate?
    private let letters = ["йцукенгшщзхъ", "фывапролджэ", "ячсмитьбю"]
    private var keys: [[Character]] = []
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
    }
    //MARK: - Setup Layout
    private func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        for row in letters {
            let chars = Array(row)
            keys.append(chars)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
//MARK: - CollectionView Delegates
extension KeyboardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else { fatalError() }
        let letter = keys[indexPath.section][indexPath.row]
        
        cell.configure(with: letter)
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 6
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 24
        let size: CGFloat = (collectionView.frame.size.width - margin) / 12
        
        return CGSize(width: size, height: size * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin: CGFloat = 24
        let size: CGFloat = (collectionView.frame.size.width - margin) / 12
        let count: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))
        let inset: CGFloat = (collectionView.frame.size.width - (size * count) - (2 * count)) / 2
        
        return UIEdgeInsets(
            top: 2,
            left: inset,
            bottom: 2,
            right: inset
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let letter = keys[indexPath.section][indexPath.row]
        delegate?.keyboardViewController(self, didTapKey: letter)
    }
}
