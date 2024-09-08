//
//  ViewController.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 04.09.2024.
//

import UIKit

protocol PopUpViewControllerDelegate: AnyObject {
    func didUpdateContent(with view: UIView)
}

enum CellMode {
    case closed
    case open
    
    mutating func toggle() {
        switch self {
        case .closed:
            self = .open
        case .open:
            self = .closed
        }
    }
}

class ViewController: UIViewController {
    // MARK: - Apps
    private let MiniApp = WordleMiniApp()
    private let MiniApp2 = CryptoExchangeMiniApp(coin: .eth)
    private let MiniApp3 = WeatherMiniApp(city: .mos)
    private let MiniApp4 = WordleMiniApp()
    private let MiniApp5 = CryptoExchangeMiniApp(coin: .btc)
    private let MiniApp6 = WeatherMiniApp(city: .spb)
    private let MiniApp7 = WordleMiniApp()
    private let MiniApp8 = CryptoExchangeMiniApp(coin: .ton)
    private let MiniApp9 = WeatherMiniApp(city: .cup)
    private let MiniApp10 = WordleMiniApp()
    private let MiniApp11 = CryptoExchangeMiniApp(coin: .eth)
    // MARK: - Properties
    private var apps = [UIViewController]()
    private let tableView = UITableView()
    private var mode: CellMode = .closed
    private var smallViewHeight: CGFloat = 0
    private var bigViewHeight: CGFloat = 0
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apps.append(MiniApp)
        apps.append(MiniApp2)
        apps.append(MiniApp3)
        apps.append(MiniApp4)
        apps.append(MiniApp5)
        apps.append(MiniApp6)
        apps.append(MiniApp7)
        apps.append(MiniApp8)
        apps.append(MiniApp9)
        apps.append(MiniApp10)
        apps.append(MiniApp11)
        
        setupLayout()
        setCellSize()
    }
    //MARK: - Methods
    private func setCellSize() {
        let height = self.view.frame.height
        let width = self.view.frame.width
        smallViewHeight = height > width ? height / 11 : width / 11
        bigViewHeight = height > width ? height / 2 : width / 2
    }
    @objc private func swapMode() {
        switch mode {
        case .closed:
            tableView.rowHeight = bigViewHeight
        case .open:
            tableView.rowHeight = smallViewHeight
        }
        tableView.reloadData()
        mode.toggle()
        
        // MARK: animation
        let cells = tableView.visibleCells
        let height = tableView.bounds.height / 4
        var delay: Double = 1.0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: height)
            UIView.animate(
                withDuration: 0.5,
                delay: delay * 0.05,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                animations: {
                    cell.transform = CGAffineTransform.identity
                })
            delay += 1.0
        }
    }
}
//MARK: - Setup Layout
extension ViewController {
    private func setupLayout() {
        setupBackground()
        setupTableView()
    }
    private func setupBackground() {
        view.backgroundColor = .systemBlue
        navigationItem.title = "Мини приложения"
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        let modeButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(swapMode)
        )
        navigationItem.rightBarButtonItem = modeButton
        navigationController?.navigationBar.tintColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = textAttributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorColor = .systemBlue
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = view.frame.height / 11
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
//MARK: - PopUpViewController Delegate
extension ViewController: PopUpViewControllerDelegate {
    func didUpdateContent(with view: UIView) {
        tableView.reloadData()
    }
    func showPopUpViewController(app: UIViewController) {
        let popUpVC = PopUpViewController(contentView: app.view)
        popUpVC.delegate = self
        popUpVC.modalPresentationStyle = .overCurrentContext
        present(popUpVC, animated: true)
    }
}
//MARK: - TableView Delegate & DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        apps.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppCell
        let app = apps[indexPath.row]
        cell.configure(miniApp: app)
        cell.selectionStyle = .none
        switch mode {
        case .closed:
            cell.fullscreenButton.isHidden = true
            cell.barrierView.isHidden = false
        case .open:
            cell.fullscreenButton.isHidden = false
            cell.barrierView.isHidden = true
        }
        cell.action = { [weak self] in
            tableView.visibleCells.forEach { $0.isHidden = true }
            self?.showPopUpViewController(app: app)
        }
        return cell
    }
}
