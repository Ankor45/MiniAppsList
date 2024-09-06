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
    let testMiniApp = AppViewController()
    let testMiniApp2 = AppViewController()
    let testMiniApp3 = AppViewController()
    let testMiniApp4 = AppViewController()
    let testMiniApp5 = AppViewController()
    let testMiniApp6 = AppViewController()
    let testMiniApp7 = AppViewController()
    let testMiniApp8 = AppViewController()
    let testMiniApp9 = AppViewController()
    let testMiniApp10 = AppViewController()
    let testMiniApp11 = AppViewController()
    let testMiniApp12 = AppViewController()
    let testMiniApp13 = AppViewController()
    let testMiniApp14 = AppViewController()
    let testMiniApp15 = AppViewController()
    let testMiniApp16 = AppViewController()
    var apps = [UIViewController]()
    
    private let tableView = UITableView()
    private var mode: CellMode = .closed
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apps.append(testMiniApp)
        apps.append(testMiniApp2)
        apps.append(testMiniApp3)
        apps.append(testMiniApp4)
        apps.append(testMiniApp5)
        apps.append(testMiniApp6)
        apps.append(testMiniApp7)
        apps.append(testMiniApp8)
        apps.append(testMiniApp9)
        apps.append(testMiniApp10)
        apps.append(testMiniApp11)
        apps.append(testMiniApp12)
        apps.append(testMiniApp13)
        apps.append(testMiniApp14)
        apps.append(testMiniApp15)
        apps.append(testMiniApp16)
        
        setupLayout()
    }
    //MARK: - Methods
    @objc private func swapMode() {
        switch mode {
        case .closed:
            tableView.rowHeight = view.bounds.height / 2
        case .open:
            tableView.rowHeight = view.bounds.height / 11
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
        tableView.rowHeight = view.bounds.height / 11
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

#Preview {
    UINavigationController(rootViewController: ViewController())
}


