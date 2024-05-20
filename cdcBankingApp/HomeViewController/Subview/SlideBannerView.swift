//
//  SlideBannerView.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

class SlideBannerView: BaseViewXib {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let pageControl = PageControlView()
    
    //Config layout
    private enum Const {
        static let itemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 128)
        static let itemSpacing = 8.0
        
        static var insetX: CGFloat {
            (UIScreen.main.bounds.width - Self.itemSize.width) / 2.0
        }
        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
        }
    }
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Const.itemSize
        layout.minimumLineSpacing = Const.itemSpacing
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    var banners: [Banner] = [] {
        didSet {
            pageControl.totalPage = bannerCount
            collectionView.reloadData()
            scrollToMiddle()
        }
    }
    
    var bannerCount: Int {
        get {
            return banners.count
        }
    }
    
    let loop = 1000
    
    private var bannerTimer: Timer?
    
    private var autoNextTime = 3.0
    
    private var previousIndex: Int = 0 {
        didSet {
            pageControl.currentPage = self.previousIndex % bannerCount
        }
    }
    
    override func setUpViews() {
        configCollectionView()
        addSubview(pageControl)
        pageControl.centerXToSuperview()
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
        pageControl.totalPage = bannerCount
    }
    
    private func configCollectionView() {
        collectionView.registerCellNib(SlideBannerCollectionViewCell.self)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.isPagingEnabled = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = Const.collectionViewContentInset
        collectionView.decelerationRate = .fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionViewFlowLayout
    }
    
    func scrollToMiddle() {
        if !banners.isEmpty {
            self.collectionView.scrollToItem(at: IndexPath(item: self.bannerCount * self.loop / 2, section: 0), at: .centeredHorizontally, animated: false)
            self.startTimer()
        }
    }
    
    func startTimer() {
        stopTimer()
        bannerTimer = Timer.scheduledTimer(timeInterval: autoNextTime,
                                           target: self,
                                           selector: #selector(bannerAutoScroll),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    func stopTimer() {
        bannerTimer?.invalidate()
        bannerTimer = nil
    }
    
    @objc private func bannerAutoScroll() {
        if !banners.isEmpty {
            if (previousIndex < bannerCount * loop - 1) && previousIndex >= 0 {
                self.collectionView.scrollToItem(
                    at: IndexPath(item: previousIndex + 1, section: 0),
                    at: .centeredHorizontally,
                    animated: true)
            } else {
                scrollToMiddle()
            }
        }
    }
}

extension SlideBannerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerCount * loop
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SlideBannerCollectionViewCell.self, indexPath: indexPath)
        cell.setData(banners[indexPath.row % bannerCount])
        return cell
    }
}

extension SlideBannerView: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Const.itemSize.width + Const.itemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth,
                                              y: scrollView.contentInset.top)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrolledOffset = scrollView.contentOffset.x + scrollView.contentInset.left
        let cellWidth = Const.itemSize.width + Const.itemSpacing
        let index = Int(round(scrolledOffset / cellWidth))
        
        defer {
            self.previousIndex = index
            self.collectionView.reloadData()
        }
        
        guard previousIndex != index else { return }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
}

