//
//  GroupsNetworkService.swift
//  Schedule.Urfu
//
//  Created by Sergey on 02/07/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation

protocol GroupsNetworkServiceDelegate: class {
    func didFinishDownloadGroups(_ sender: GroupsNetworkService)
}

class GroupsNetworkService {
    
    weak var networkDelegate: GroupsNetworkServiceDelegate?

    func getGroups(arg: Bool, completion: @escaping (Bool) -> ()) {
        var groups = [GroupData]()
        guard let url = URL(string: "https://urfu.ru/api/schedule/groups/") else { return }
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                groups = try decoder.decode([GroupData].self, from: data)
            } catch let err {
                print("Err", err)
            }
            GroupsCoreDataService().saveGroups(groups: groups)
            completion(arg)
            self.didDownloadGroups()
            }.resume()
    }
    
    func didDownloadGroups() {
        networkDelegate?.didFinishDownloadGroups(self)
    }
}
