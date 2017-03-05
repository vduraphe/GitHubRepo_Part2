//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

class Preferences {
    var minStarRating = 30000
}

class RepoResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var reposTableView: UITableView!

    var searchBar: UISearchBar!
    var preferences: Preferences = Preferences()
    var searchSettings = GithubRepoSearchSettings()
    var repos: [GithubRepo]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchSettings.minStars = preferences.minStarRating

        reposTableView.dataSource = self
        reposTableView.delegate = self
                
        
        searchBar = UISearchBar()
        searchBar.delegate = self

      
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

      
        doSearch()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            let navController = segue.destination as! UINavigationController
            let settingsVC = navController.topViewController as! SettingsViewController
            settingsVC.currentPrefs = self.preferences
        }
    }

    @IBAction func didSaveSettings(_ segue: UIStoryboardSegue){
        if let settingsVC = segue.source as? SettingsViewController{
            self.preferences = settingsVC.preferencesFromTableData()
            self.searchSettings.minStars = self.preferences.minStarRating
        }
        doSearch()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repos = self.repos {
            return repos.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.jayliew.ReposViewCell", for: indexPath) as! ReposViewCell
        let repo = self.repos[indexPath.row]
        
        cell.avatarImageView.setImageWith(URL(string: repo.ownerAvatarURL!)!)
        cell.nameLabel.text = repo.name
        cell.nameLabel.sizeToFit()
        
        cell.descriptionLabel.text = repo.repoDescription
        cell.ownerLabel.text = repo.ownerHandle
        cell.forksLabel.text = String(repo.forks!)
        cell.starsLabel.text = String(repo.stars!)
        cell.language = repo.language
        
        cell.clipsToBounds = true
        
        return cell
    }


    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in
            self.repos = [GithubRepo]()
            for repo in newRepos {
                print(repo.stars)
                self.repos.append(repo)
            }
            self.reposTableView.reloadData()
            
            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
}


extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}
