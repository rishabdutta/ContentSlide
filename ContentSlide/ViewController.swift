//
//  ViewController.swift
//  ContentSlide
//
//  Created by Rishab Dutta on 12/03/18.
//  Copyright © 2018 Rishab Dutta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let MinimumSpacingForTabCollectionView: CGFloat = 1.0
    
    private let TabCellID = "TabCollectionViewCell"
    private let ContentCellId  = "ContentCollectionViewCell"
    
    private var slideViewLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var collectionHolderView: UIView!
    
    @IBOutlet weak var tabCollectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = MinimumSpacingForTabCollectionView
            layout.minimumInteritemSpacing = MinimumSpacingForTabCollectionView
            
            layout.scrollDirection = .horizontal
            tabCollectionView.collectionViewLayout = layout
            let nib = UINib(nibName: TabCellID, bundle: nil)
            tabCollectionView.register(nib, forCellWithReuseIdentifier: TabCellID)
        }
    }
    
    private lazy var slideView: UIView = {
        let sView = UIView()
        sView.translatesAutoresizingMaskIntoConstraints = false
        sView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        return sView
    }()
    
    @IBOutlet weak var contentCollectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0.0
            layout.minimumLineSpacing = 0.0
            layout.scrollDirection = .horizontal
            
            contentCollectionView.collectionViewLayout = layout
            contentCollectionView.isPagingEnabled = true
            
            let nib = UINib(nibName: ContentCellId, bundle: nil)
            contentCollectionView.register(nib, forCellWithReuseIdentifier: ContentCellId)
        }
    }
    
    var datasourceForTab = ["HOME", "SUBSCRIPTION", "ACTVITY", "COMMENT"]
    var datasourceForContent = ["No", "content", "is", "required"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViews()
    }

    private func setupViews() {
        // Do any additional setup after loading the view, typically from a nib.
        tabCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        collectionHolderView.addSubview(slideView)
        slideViewLeadingConstraint = slideView.leadingAnchor.constraint(equalTo: collectionHolderView.leadingAnchor)
        NSLayoutConstraint.activate([
            slideViewLeadingConstraint
            , slideView.bottomAnchor.constraint(equalTo: collectionHolderView.bottomAnchor)
            , slideView.widthAnchor.constraint(equalToConstant: (tabCollectionView.frame.width / 4) - MinimumSpacingForTabCollectionView)
            , slideView.heightAnchor.constraint(equalToConstant: 5)
            ])
    }    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        if collectionView == tabCollectionView {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCellID, for: indexPath) as! TabCollectionViewCell
            myCell.label.text = datasourceForTab[indexPath.item]
            cell = myCell
        }
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellId, for: indexPath) as! ContentCollectionViewCell
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentCollectionView {
            return collectionView.frame.size
        }
        else {
            return CGSize(width: tabCollectionView.frame.width / 4 - MinimumSpacingForTabCollectionView, height: tabCollectionView.frame.height)
        }
    }
}

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        slideViewLeadingConstraint.constant = scrollView.contentOffset.x / CGFloat(tabCollectionView.numberOfItems(inSection: 0))
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(targetContentOffset.pointee)
        let item = Int(targetContentOffset.pointee.x / contentCollectionView.frame.width)
        tabCollectionView.selectItem(at: IndexPath(item: item, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}


















