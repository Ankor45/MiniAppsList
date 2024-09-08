//
//  WordleMiniApp.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 08.09.2024.
//
import UIKit

class WordleMiniApp: UIViewController {
    //MARK: - Properties
    private let answers = ["книга", "пирог", "сфера", "шпага", "ствол"]
    private var answer = ""
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 3)
    private let clearButton = UIButton(type: .close)
    private let titleLabel = UILabel()
    private let keyboardVC = KeyboardViewController()
    private let boardVC = BoardViewController()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? "книга"
        
        setupLayout()
    }
    override func viewWillLayoutSubviews() {
        if self.view.bounds.height < 400 {
            keyboardVC.view.isHidden = true
            boardVC.view.isHidden = true
            clearButton.isHidden = true
        } else {
            keyboardVC.view.isHidden = false
            boardVC.view.isHidden = false
        }
    }
}
//MARK: - Setup Layout
extension WordleMiniApp {
    private func setupLayout() {
        setUpBackground()
        setupTitleLabel()
        setupBoard()
        setupKeyboard()
        setupClearButton()
    }
    private func setUpBackground() {
        view.backgroundColor = .white
    }
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "Wordle game"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25)
        ])
    }
    private func setupKeyboard() {
        addChild(keyboardVC)
        view.addSubview(keyboardVC.view)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            keyboardVC.view.topAnchor.constraint(equalTo: boardVC.view.bottomAnchor),
            keyboardVC.view.widthAnchor.constraint(equalToConstant: view.bounds.height / 3),
            keyboardVC.view.heightAnchor.constraint(equalToConstant: view.bounds.height / 5),
            keyboardVC.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func setupBoard() {
        view.addSubview(boardVC.view)
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.dataSource = self
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            boardVC.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardVC.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            boardVC.view.widthAnchor.constraint(equalToConstant: view.bounds.height / 3),
            boardVC.view.heightAnchor.constraint(equalToConstant: view.bounds.height / 4.6)
        ])
    }
    private func setupClearButton() {
        view.addSubview(clearButton)
        clearButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearBoard), for: .touchUpInside)
        clearButton.isHidden = true
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.topAnchor.constraint(equalTo: keyboardVC.view.topAnchor , constant: -10)
        ])
    }
}
//MARK: Game Logic
extension WordleMiniApp: KeyboardViewControllerDelegate {
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        var stop = false
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }
        boardVC.reloadData()
        if !stop {
            clearButton.isHidden = false
        }
    }
}
extension WordleMiniApp: BoardViewControllerDataSource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        let count = guesses[rowIndex].compactMap({ $0 }).count
        
        guard count == 5 else { return nil }
        let indexAnswer = Array(answer)
        
        guard let letter = guesses[indexPath.section][indexPath.row], indexAnswer.contains(letter) else { return nil }
        if indexAnswer[indexPath.row] == letter {
            return .blue
        }
        return .systemGray3
    }
    
    @objc private func clearBoard() {
        guesses = Array(repeating: Array(repeating: nil, count: 5), count: 3)
        clearButton.isHidden.toggle()
        boardVC.reloadData()
    }
}
