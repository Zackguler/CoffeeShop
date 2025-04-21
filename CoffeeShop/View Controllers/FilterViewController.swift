//
//  FilterViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

//
//  FilterViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import SnapKit

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilter(categories: [String], sortAscending: Bool?)
}

final class FilterViewController: UIViewController {

    weak var delegate: FilterViewControllerDelegate?

    private var selectedCategories: Set<String> = []
    private var selectedSort: Bool? = nil

    private let categories = [
        ("filter_hot".localized, "hot"),
        ("filter_cold".localized, "cold"),
        ("filter_food".localized, "food")
    ]

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private var applyButton: CustomButton!

    private var sortViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        contentView.axis = .vertical
        contentView.spacing = 24
        contentView.alignment = .leading
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.width.equalToSuperview().inset(16)
        }

        contentView.addArrangedSubview(makeSectionLabel("filter_categories".localized))

        for (display, value) in categories {
            let view = makeCheckboxRow(title: display, key: value)
            contentView.addArrangedSubview(view)
        }

        contentView.addArrangedSubview(makeSectionLabel("filter_sort_title".localized))

        let ascending = makeCheckboxRow(title: "filter_sort_asc".localized, key: "ascending")
        let descending = makeCheckboxRow(title: "filter_sort_desc".localized, key: "descending")
        sortViews = [ascending, descending]

        contentView.addArrangedSubview(ascending)
        contentView.addArrangedSubview(descending)

        applyButton = CustomButton(action: { [weak self] in
            self?.applyFilter()
        })
        applyButton.setTitle("filter_button_title".localized, for: .normal)
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }

    private func makeSectionLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.fontBold24
        label.textColor = Colors().colorMidBlack
        return label
    }

    private func makeCheckboxRow(title: String, key: String) -> UIView {
        let container = UIView()
        container.isUserInteractionEnabled = true
        container.accessibilityLabel = key

        let icon = UIImageView(image: UIImage(named: "checked_none"))
        icon.contentMode = .scaleAspectFit
        icon.tag = 1001

        let label = UILabel()
        label.text = title
        label.textColor = Colors().colorDarkGray
        label.font = UIFont.fontRegular16

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center

        container.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped(_:)))
        container.addGestureRecognizer(tap)

        return container
    }

    @objc private func checkboxTapped(_ gesture: UITapGestureRecognizer) {
        guard let container = gesture.view,
              let icon = container.subviews.first(where: { $0 is UIStackView })?.subviews.first(where: { $0.tag == 1001 }) as? UIImageView,
              let key = container.accessibilityLabel else { return }

        if key == "ascending" || key == "descending" {
            sortViews.forEach { sortView in
                if let icon = sortView.subviews.first(where: { $0 is UIStackView })?.subviews.first(where: { $0.tag == 1001 }) as? UIImageView {
                    icon.image = UIImage(named: "checked_none")
                }
            }
            icon.image = UIImage(named: "checked")
            selectedSort = (key == "ascending")
        } else {
            if selectedCategories.contains(key) {
                selectedCategories.remove(key)
                icon.image = UIImage(named: "checked_none")
            } else {
                selectedCategories.insert(key)
                icon.image = UIImage(named: "checked")
            }
        }
    }

    @objc private func applyFilter() {
        delegate?.didApplyFilter(categories: Array(selectedCategories), sortAscending: selectedSort)
        dismiss(animated: true)
    }
}
