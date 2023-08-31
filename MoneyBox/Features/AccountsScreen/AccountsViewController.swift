//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import UIKit

class AccountsViewController: UIViewController {
    
    @IBOutlet weak var accountsCollectionView: UICollectionView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCollectionView()
    }
    
    func setupCollectionView() {
        accountsCollectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: "accountCell")
    }
}

extension AccountsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath)
            as? AccountCollectionViewCell
            else { fatalError("Could not find account cell") }
        cell.planNameLabel.text = "foo"
        cell.planValueLabel.text = "\(Int.random(in: 1...3))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}
