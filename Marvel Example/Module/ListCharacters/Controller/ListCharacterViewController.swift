//
//  ListCharacterViewController.swift
//  Marvel Example
//
//  Created by Tiago Coelho on 23/7/20.
//  Copyright © 2020 Tiago Coelho. All rights reserved.
//

import UIKit

class ListCharacterViewController: UIViewController {
    
    @IBOutlet weak var characterTableView: UITableView!
    
    private let reuseCellIdentifier = "ListCharacterCell"
    private let reuseLoadingCellId = "ListCharacterLoadingCell"
    
    lazy var model: ListCharacterViewModel = ListCharacterViewModel(updateMethod: self.updateView)
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.characterTableView.dataSource = self
        self.characterTableView.delegate = self
        
        self.characterTableView.register(UINib(nibName: reuseCellIdentifier, bundle: nil), forCellReuseIdentifier: reuseCellIdentifier)
        self.characterTableView.register(UINib(nibName: reuseLoadingCellId, bundle: nil), forCellReuseIdentifier: reuseLoadingCellId)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.model.fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? CharacterDetailsViewController, let hero = sender as? Character {
            detailsVC.character = hero
        }
    }
    
    private func updateView(){
        self.characterTableView.reloadData()
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                // Fake background loading task for 2 seconds
                sleep(2)
                // Download more data here
                DispatchQueue.main.async {
                    self.model.fetchData()
                    self.isLoading = false
                }
            }
        }
    }
}

extension ListCharacterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Section with character items
            return self.model.characterList?.count ?? 0
        } else if section == 1 {
            // Section for the loading cell
            return 1
        }else {
            return 0
        }
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
             // Section with character items
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as! ListCharacterCellViewController
            cell.model = self.model.characterList![indexPath.row]
            
            return cell
        } else {
             // Section for the loading cell
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseLoadingCellId, for: indexPath) as! ListCharacterLoadingCell
            if self.model.noResults {
                cell.activityIndicator.isHidden = true
                cell.noResultLabel.isHidden = false
            } else {
                cell.activityIndicator.isHidden = false
                cell.noResultLabel.isHidden = true
                cell.activityIndicator.startAnimating()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "openHeroDetailSegue", sender: self.model.characterList?[indexPath.row])
   
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 4) && !self.isLoading {
            self.loadMoreData()
        }
    }
}
