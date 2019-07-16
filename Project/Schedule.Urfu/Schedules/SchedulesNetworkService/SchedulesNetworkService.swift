//
//  SchedulesNetworkService.swift
//  Schedule.Urfu
//
//  Created by Sergey on 02/07/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
import SwiftSoup

protocol SchedulesNetworkServiceDelegate: class {
    func didFinishDownloadSchedules(_ sender: SchedulesNetworkService)
}

class SchedulesNetworkService: SchedulesCoreDataService {
    
    weak var networkDelegate: SchedulesNetworkServiceDelegate?
    
    func getSchedules(favouriteGroupId: String, arg: Bool, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: "https://urfu.ru/api/schedule/groups/lessons/\(favouriteGroupId)/") else { return }
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let htmlData = data else { return }
            let schedules = self.parseSchedules(data: htmlData)
            self.saveSchedule(schedules: schedules)
            completion(arg)
            }.resume()
    }
    
    func parseSchedules(data: Data) -> [ScheduleData] {
        let currentYear = Calendar.current.component(.year, from: Date())
        var schedules = [ScheduleData]()
        
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: UserDefaults.standard.getLanguage())
            dateFormatter.dateFormat = "d MMM yyyy'T'HH:mm:ssZ"
            return dateFormatter
        }()
        
        do {
        let doc: Document = try SwiftSoup.parse(String(data: data, encoding: .utf8)!)
        for lesson in try doc.select("table") {
            var schedule = ScheduleData(date: Date(), lessons: [String](), cabinet: [String](), teacher: [String]())
            for item in try lesson.select("tr").array() {
                if try !item.select(".divide").attr("colspan","3").text().isEmpty {
                    let date = formatter.date(from: "\(try item.select(".divide").attr("colspan","3").text()) \(currentYear)T00:00:00+0000")
                    schedule.date = date
                }
                if try !item.select("dd").text().isEmpty {
                    schedule.teacher?.append(try item.select(".teacher").text())
                    schedule.cabinet?.append(try item.select(".cabinet").text())
                    schedule.lessons?.append(try item.select("dd").text())
                }
                if try item.select(".divide").attr("colspan","3").text().isEmpty &&  !item.select(".divide").attr("colspan","3").html().isEmpty  {
                    schedules.append(schedule)
                    schedule = ScheduleData(date: Date(), lessons: [String](), cabinet: [String](), teacher: [String]())
                }
            }
        }
        } catch {
            fatalError("Unresolved error \(error)")
        }
        return schedules
    }
    func didDownloadSchedules() {
        networkDelegate?.didFinishDownloadSchedules(self)
    }
}
