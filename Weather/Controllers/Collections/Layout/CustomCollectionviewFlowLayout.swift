//
//  CustomCollectionviewFlowLayout.swift
//  Weather
//
//  Created by Alexsandre kikalia on 2/4/21.
//

import UIKit



protocol CustomCollectionViewFlowLayoutDelegate: AnyObject{
    func ccvfdidChangeCurrentPage(sender: CustomCollectionViewFlowLayout, row: Int)
    func ccvfgetCurrentPage(sender: CustomCollectionViewFlowLayout) -> Int
}

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {

    var previousOffset: CGFloat = 0
    private var currentPage: Int = 0

    weak var delegate: CustomCollectionViewFlowLayoutDelegate?
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        let itemsCount = collectionView.numberOfItems(inSection: 0)

        if previousOffset > collectionView.contentOffset.x && velocity.x < 0 {
            currentPage = max(currentPage - 1, 0)
        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0 {
            currentPage = min(currentPage + 1, itemsCount - 1)
        }

        let updatedOffset = newOffset()
        previousOffset = updatedOffset
        
        delegate?.ccvfdidChangeCurrentPage(sender: self, row: currentPage)
        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let updatedOffset = newOffset()
        previousOffset = updatedOffset
        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }
    
    func newOffset() -> CGFloat{
        return (itemSize.width + minimumLineSpacing) * CGFloat(currentPage)
    }
    
    
//    override func finalizeLayoutTransition() {
//        super.finalizeLayoutTransition()
//        let updatedOffset = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage)
//        previousOffset = updatedOffset
//    }
}
