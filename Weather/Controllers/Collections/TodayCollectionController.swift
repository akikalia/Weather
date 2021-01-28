//
//  TodayCollectionController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/28/21.
//

import UIKit

class TodayCollectionController: UIViewController {
    
    
    @IBOutlet var collectionView : UICollectionView!
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            UINib(nibName: "CityCell", bundle: nil),
            forCellWithReuseIdentifier: "CityCell"
        )
        
        fetchCities()
    }
    func fetchCities(){
        
    }
}

extension TodayCollectionController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath)
        if let cellEdit: ContactCell = cell as? ContactCell{
            cellEdit.delegate = self
            cellEdit.name.text = getFirstName(fullName: contacts[indexPath.row].name)
            cellEdit.fullName = contacts[indexPath.row].name ?? ""
            cellEdit.initials.text = getInitials(name: contacts[indexPath.row].name)
            cellEdit.number.text = contacts[indexPath.row].phone_number
            cellEdit.id = indexPath.row
        }
        return cell
    }
    
}


extension TodayCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.Insets.top, left: Constants.Insets.left, bottom: Constants.Insets.bottom, right: Constants.Insets.right)
    }
    

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.spacingX
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.spacingY
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath ) -> CGSize {

        var width = CGFloat.init(125)
        
        if collectionView.frame.width <= 428{
            let innerWidth = collectionView.frame.width - Constants.Insets.left - Constants.Insets.right
           width = (innerWidth - (Constants.numCols-1) * Constants.spacingX) / Constants.numCols
        }
        
        return CGSize(width: width - 1, height: 1.3 * width)
    }

    
}
extension TodayCollectionController: ContactCellDelegate{
    func contactCellDelegateLongPress(_ sender: ContactCell, id: Int, name: String?) {
        let alert = UIAlertController(
            title: "Delete Contact?",
            message: "contact " + (name ?? "")  + " will be deleted",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            self.deleteContact(index: id)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension TodayCollectionController {
    
    struct Constants {
        static let numCols : CGFloat = 3
        static let spacingX: CGFloat = 12
        static let spacingY: CGFloat = 20
        struct Insets {
            static let top : CGFloat = 12
            static let bottom : CGFloat = 12
            static let left : CGFloat = 12
            static let right : CGFloat = 12
        }
    }
}

