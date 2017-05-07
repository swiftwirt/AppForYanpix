//
//  AFYPhotoesCollectionViewController.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/7/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class AFYPhotoesCollectionViewController: UICollectionViewController {
    
    var imageLinks = [URL?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageLinks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AFYPhotoCollectionViewCell
    
        let link = imageLinks[indexPath.row]
        cell.imageLink = link
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "SegueToDetails":
                guard let cell = sender as? AFYPhotoCollectionViewCell else { return }
                let controller = segue.destination as! AFYPhotoDetailsViewController
                controller.imageLink = cell.imageLink
            default:
                break
        }
    }
}
