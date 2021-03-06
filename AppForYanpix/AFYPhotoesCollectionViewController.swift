//
//  AFYPhotoesCollectionViewController.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/7/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYPhotoesCollectionViewController: UICollectionViewController {
    
    struct ReuseIdentifier {
        static let photoCell = "PhotoCell"
        
        private init() {}
    }
    
    struct SegueIdentifier {
        static let toDetails = "SegueToDetails"
        
        private init() {}
    }
    
    var location: Location!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = .default
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return location.relatedLocations.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.photoCell, for: indexPath) as! AFYPhotoCollectionViewCell
        
        switch indexPath.row {
            case 0:
            cell.location = location
            default:
            cell.location = location.relatedLocations[indexPath.row - 1]
        }
        return cell
    }

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case SegueIdentifier.toDetails:
                guard let cell = sender as? AFYPhotoCollectionViewCell else { return }
                let controller = segue.destination as! AFYPhotoDetailsViewController
                controller.link = cell.location.standartResolutionImageLink
            default:
                break
        }
    }
}
