//
//  CampaignsSliderView.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import SnapKit

final class CampaignsSliderView: UIView {

    private var campaigns: [Campaign] = []
    private var timer: Timer?
    private var currentIndex: Int = 0

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CampaignSliderCell.self, forCellWithReuseIdentifier: "CampaignSliderCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        collectionView.setCornerRound(value: 20)
        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.currentPageIndicatorTintColor = .black
        page.pageIndicatorTintColor = .lightGray
        return page
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startAutoScroll()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.bounds.width, height: 230)
            layout.invalidateLayout()
        }
    }

    private func setupUI() {
        addSubview(collectionView)
        addSubview(pageControl)

        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(230)
        }

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func update(with campaigns: [Campaign]) {
        self.campaigns = campaigns
        pageControl.numberOfPages = campaigns.count
        currentIndex = 0
        collectionView.reloadData()

        DispatchQueue.main.async {
            self.scrollToIndex(0)
            self.startAutoScroll()
        }
    }

    private func startAutoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { [weak self] _ in
            self?.scrollToNextItem()
        }
    }
    
    private func scrollToNextItem() {
        guard !campaigns.isEmpty else { return }
        
        let nextIndex = (currentIndex + 1) % campaigns.count
        let nextOffset = CGPoint(x: CGFloat(nextIndex) * collectionView.frame.width, y: 0)
        
        collectionView.setContentOffset(nextOffset, animated: true)
        currentIndex = nextIndex
        pageControl.currentPage = currentIndex
    }

    private func scrollToIndex(_ index: Int) {
        print(index)
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = index
    }

    deinit {
        timer?.invalidate()
    }
}

extension CampaignsSliderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaigns.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignSliderCell", for: indexPath) as! CampaignSliderCell
        cell.configure(with: campaigns[indexPath.item])
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = page
        currentIndex = page
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = page
        currentIndex = page
    }
}
