//
//  ViewController.swift
//  Tracker
//
//  Created by Kirill Sklyarov on 12.03.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    private let swooshImage = UIImageView()
    private let textLabel = UILabel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var categories: [TrackerCategory]?
    private var completedTrackers: [TrackerRecord]?
    
    private let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        setupNavigation()
        
        setupSearchController()
        
        setupCollectionView()
        
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(LetterCollectionViewCell.self, forCellWithReuseIdentifier: LetterCollectionViewCell.identifier)
        
        collectionView.register(SuplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(SuplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        
        view.addSubViews([collectionView])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        let swooshSize = CGFloat(80)
        swooshImage.image = UIImage(named: "swoosh")
        
        textLabel.text = "Что будем отслеживать?"
        textLabel.font = .systemFont(ofSize: 12, weight: .medium)
        textLabel.textAlignment = .center
        
        view.addSubViews([collectionView, swooshImage, textLabel])
        
        NSLayoutConstraint.activate([
            
            swooshImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swooshImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            swooshImage.heightAnchor.constraint(equalToConstant: swooshSize),
            swooshImage.widthAnchor.constraint(equalToConstant: swooshSize),
            
            textLabel.topAnchor.constraint(equalTo: swooshImage.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupNavigation() {
        
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal)
        
        lazy var datePicker: UIDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.locale = Locale(identifier: "ru_RU")
            datePicker.calendar = Calendar(identifier: .gregorian)
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(datePickerTapped), for: .valueChanged)
            return datePicker
        } ()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image?.withTintColor(.black), style: .done, target: self, action: #selector(addNewHabit))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
    }
    
    @objc private func datePickerTapped(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    @objc private func addNewHabit(_ sender: UIButton) {
        let creatingNewHabitVC = ChoosingTypeOfHabitViewController()
        let creatingNavi = UINavigationController(rootViewController: creatingNewHabitVC)
        present(creatingNavi, animated: true)
    }
}

extension TrackerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        alphabet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCollectionViewCell.identifier, for: indexPath) as? LetterCollectionViewCell else { print("We have some problems with CustomCell");
            return UICollectionViewCell()
        }
        cell.titleLabel.text = alphabet[indexPath.row].uppercased()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id = ""
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! SuplementaryView
        view.label.text = "Здесь находится Suplementary View"
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? LetterCollectionViewCell
        cell?.titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? LetterCollectionViewCell
        cell?.titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else { return nil}
        
        let indexPath = indexPaths[0]
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Bold") { [weak self] _ in
                    self?.makeBold(indexPath: indexPath)
                },
                UIAction(title: "Italic") { [weak self] _ in
                    self?.makeItalic(indexPath: indexPath)
                }
            ])
        })
    }
    
    func makeBold(indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCollectionViewCell.identifier, for: indexPath) as? LetterCollectionViewCell
        cell?.titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    func makeItalic(indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCollectionViewCell.identifier, for: indexPath) as? LetterCollectionViewCell
        cell?.titleLabel.font = .italicSystemFont(ofSize: 17)
    }
    
    
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let footerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath)
        
        return footerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 4 - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

//MARK: - SwiftUI
import SwiftUI
struct ProviderTracker : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return TrackerViewController()
        }
        
        typealias UIViewControllerType = UIViewController
        
        
        let viewController = TrackerViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderTracker.ContainterView>) -> TrackerViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: ProviderTracker.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderTracker.ContainterView>) {
            
        }
    }
}
