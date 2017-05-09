//
//  AFYSsavedPhotoesViewController.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/9/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYSavedPhotoesViewController: UICollectionViewController {
    
    struct ReuseIdentifier {
        static let photoCell = "SavedPhotoCell"
        
        private init() {}
    }
    
    struct SegueIdentifier {
        static let toDetails = "SegueToDetails"
        
        private init() {}
    }
    
    var links: [String]!
    
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
        return links.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.photoCell, for: indexPath) as! AFYSavedPhotoViewCell
        cell.link = links[indexPath.row]
        return cell
    }
    
    // MARK: - Segue 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SegueIdentifier.toDetails:
            guard let cell = sender as? AFYSavedPhotoViewCell, let url = URL(string: cell.link) else { return }
            let controller = segue.destination as! AFYPhotoDetailsViewController
            controller.link = url
        default:
            break
        }
    }
}
