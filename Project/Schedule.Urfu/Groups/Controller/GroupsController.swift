//
//  SearchViewController.swift
//  SecApp
//
//  Created by Sergey on 27/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit

class GroupsController: UIViewController, UISearchBarDelegate{

    var fetchedGroups:[Group] = []
    var filteredGroups:[Group] = []
    var groupsCoreDataService: GroupsCoreDataService? = GroupsCoreDataService()
    var groupsNetworkService: GroupsNetworkService? = GroupsNetworkService()
    var schedulesCoreDataService: SchedulesCoreDataService? = SchedulesCoreDataService()
    var schedulesNetworkService: SchedulesNetworkService? = SchedulesNetworkService()
    
    var selectedGroupTitle = ""
    var selectedGroupId = ""
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = "Найти свою группу"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        return searchController
    }()
    
    private func performGroupsFetch(complition: (Bool) -> ()) {
        do{
            try groupsCoreDataService?.groupFetchedResultsController.performFetch()
            fetchedGroups = groupsCoreDataService?.groupFetchedResultsController.fetchedObjects?.reversed() ?? []
            filteredGroups = fetchedGroups
        } catch {
            print(error)
        }
        complition(true)
    }
    
    override func viewDidLoad() {
        groupsCoreDataService?.dataDelegate = self
        groupsNetworkService?.networkDelegate = self
        schedulesCoreDataService?.dataDelegate = self
        schedulesNetworkService?.networkDelegate = self
        navigationItem.title = "Поиск"
        view.addSubview(tableView)
        searchController.isActive = true
        tableView.register(GroupCell.self, forCellReuseIdentifier: "cellGroup")
        tableView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        performGroupsFetch { (success) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    @objc func downloadGroups(notification: NSNotification) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        groupsNetworkService?.getGroups(arg: true) { (success) in
            self.performGroupsFetch { (true) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension GroupsController: GroupsCoreDataServiceDelegate, GroupsNetworkServiceDelegate, SchedulesNetworkServiceDelegate, SchedulesCoreDataServiceDelegate {
    func didFinishSavingSchedules(_ sender: SchedulesCoreDataService) { }
    func didFinishDownloadSchedules(_ sender: SchedulesNetworkService) { }
    func didFinishDownloadGroups(_ sender: GroupsNetworkService) { }
    func didFinishSavingGroups(_ sender: GroupsCoreDataService) { }
}

extension GroupsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && !searchController.searchBar.text!.isEmpty {
            return filteredGroups.count
        } else {
            return fetchedGroups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGroup", for: indexPath) as! GroupCell
        if searchController.isActive && !searchController.searchBar.text!.isEmpty {
            cell.groupLabel.text = filteredGroups[indexPath.row].title
        } else {
            cell.groupLabel.text = fetchedGroups[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let schedulesController = SchedulesController()
        guard let selectedGroupTitle = filteredGroups[indexPath.row].title else { return }
        guard let selectedGroupId = filteredGroups[indexPath.row].id else { return }
        UserDefaults.standard.setDefaultGroup(title: selectedGroupTitle, id: selectedGroupId)
        schedulesCoreDataService?.deleteSchedules()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if Reachability.isConnectedToNetwork(){
            schedulesNetworkService?.getSchedules(favouriteGroupId: selectedGroupId, arg: true, completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshSchedulesTable"), object: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400), execute: {
                        self.navigationController?.pushViewController(schedulesController, animated: true)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    })
                }
            })
        } else {
            let alert = UIAlertController(title: "Internet Connection not available", message: "Check your Internet Connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension GroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.lowercased() != nil && !searchController.searchBar.text!.isEmpty {
            let text = searchController.searchBar.text!.lowercased()
            filteredGroups = fetchedGroups.filter({ (group) -> Bool in
                return group.title!.lowercased().contains(text)
            })
        } else {
            filteredGroups = fetchedGroups
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

