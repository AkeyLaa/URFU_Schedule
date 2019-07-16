//
//  ScheduleController.swift
//  Schedule.Urfu
//
//  Created by Sergey on 02/07/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit
import CoreData
import SwiftSoup
import ScrollableDatepicker

class SchedulesController: UIViewController {
    
    var schedules: [Schedule] = []
    var selectedDateIndex: Int = 0
    let scheduleCell = "scheduleCell"
    var favouriteGroupTitle: String = "None"
    var favouriteGroupId: String = "None"
    
    var schedulesCoreDataService: SchedulesCoreDataService? = SchedulesCoreDataService()
    var schedulesNetworkService: SchedulesNetworkService? = SchedulesNetworkService()
    
    lazy var datePicker: ScrollableDatepicker = {
        let datepicker = ScrollableDatepicker()
        var dates = [Date]()
        for index in 0...schedules.count-1 {
            if let date = schedules[index].date {
                dates.append(date)
            }
        }
        datepicker.dates = dates
        datepicker.selectedDate = Date()
        datepicker.delegate = self
        var configuration = Configuration()
        configuration.defaultDayStyle.dateTextFont = UIFont.systemFont(ofSize: 17)
        configuration.weekendDayStyle.dateTextColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        configuration.weekendDayStyle.dateTextFont = UIFont.boldSystemFont(ofSize: 17)
        configuration.weekendDayStyle.weekDayTextColor = UIColor(red: 242.0/255.0, green: 93.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        configuration.selectedDayStyle.backgroundColor = UIColor(white: 0.9, alpha: 1)
        configuration.daySizeCalculation = .numberOfVisibleItems(7)
        datepicker.configuration = configuration
        return datepicker
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame = self.view.frame
        let label = UILabel(frame: CGRect(x: view.center.x, y: view.center.y, width: 100, height: 30))
        label.text = "Пусто"
        label.center = view.center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textAlignment = .center
        label.textColor = .lightGray
        view.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        view.addSubview(label)
        view.addSubview(label)
        return view
    }()
    
    lazy var topImageView: UIView = {
        let image = UIImage(named: "UrFULogo_U")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = topImageView
        favouriteGroupTitle = UserDefaults.standard.getDefaultGroup().keys.first!
        favouriteGroupId = UserDefaults.standard.getDefaultGroup().values.first!
        title = favouriteGroupTitle
        performSchedulesFetch { (success) in
            if !schedules.isEmpty {
                navigationItem.largeTitleDisplayMode = .always
                containerView.removeFromSuperview()
                view.addSubview(datePicker)
                view.addSubview(tableView)
                _ = datePicker.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
                _ = tableView.anchor(top: datePicker.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            } else {
                navigationItem.largeTitleDisplayMode = .never
                view.addSubview(containerView)
            }
            DispatchQueue.main.async {
                self.tableView.reloadWithAnimation()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schedulesCoreDataService?.dataDelegate = self
        schedulesNetworkService?.networkDelegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleSingOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchGroup))
        NotificationCenter.default.addObserver(self, selector: #selector(refreshSchedulesTable) , name: NSNotification.Name(rawValue: "refreshSchedulesTable"), object: nil)
        registerCells()
    }
    
    @objc private func handleSingOut() {
        UserDefaults.standard.setDefaultGroup(title: "", id: "")
        schedulesCoreDataService?.deleteSchedules()
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc private func refreshSchedulesTable(notification: NSNotification) {
        performSchedulesFetch { (success) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func handleSearchGroup() {
        let groupsController = GroupsController()
        navigationController?.pushViewController(groupsController, animated: true)
    }
}

extension SchedulesController: ScrollableDatepickerDelegate{
    
    public var topDistance : CGFloat{
        get {
            if navigationController != nil && !navigationController!.navigationBar.isTranslucent{
                return 0
            } else {
                let barHeight = self.navigationController?.navigationBar.frame.height ?? 0
                let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                return barHeight + statusBarHeight
            }
        }
    }
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        for index in 0...schedules.count-1 {
            if date == schedules[index].date {
                selectedDateIndex = index
                DispatchQueue.main.async {
                    self.tableView.reloadWithAnimation()
                }
            }
        }
    }
}
private var finishedLoadingInitialTableCells = false
extension SchedulesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedules.isEmpty {
            return 0
        } else {
            if schedules[selectedDateIndex].lessons?.count == 0 {
                return 1
            } else {
                return schedules[selectedDateIndex].lessons?.count ?? 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCell, for: indexPath) as! ScheduleCell
        if schedules[selectedDateIndex].lessons?.count != 0 {
            cell.lessonLabel.text = schedules[selectedDateIndex].lessons?[indexPath.row]
            cell.teacherLabel.text = schedules[selectedDateIndex].teacher?[indexPath.row]
            cell.timeLabel.text = schedules.first?.timeArray[Int(String((schedules[selectedDateIndex].lessons?[indexPath.row].first)!))! - 1]
            cell.cabinetLabel.text = schedules[selectedDateIndex].cabinet?[indexPath.row]
            switch schedules[selectedDateIndex].teacher?[indexPath.row].first {
            case "л":
                cell.lineSeparatorView.backgroundColor = .green
            case "п":
                cell.lineSeparatorView.backgroundColor = .red
            case "з":
                cell.lineSeparatorView.backgroundColor = .purple
            default:
                cell.lineSeparatorView.backgroundColor = .black
            }
        } else {
            cell.lessonLabel.text = "Занятий не намечается..."
            cell.timeLabel.text = nil
            cell.teacherLabel.text = nil
            cell.cabinetLabel.text = nil
            cell.lineSeparatorView.backgroundColor = .lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func registerCells() {
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: scheduleCell)
    }
}

extension SchedulesController: SchedulesCoreDataServiceDelegate, SchedulesNetworkServiceDelegate{
    
    func didFinishSavingSchedules(_ sender: SchedulesCoreDataService) { }
    func didFinishDownloadSchedules(_ sender: SchedulesNetworkService) { }
    
}

extension SchedulesController {
    func performSchedulesFetch(completion: (Bool) -> ()) {
        do{
            try schedulesCoreDataService?.scheduleFetchedResultsController.performFetch()
            schedules = schedulesCoreDataService?.scheduleFetchedResultsController.fetchedObjects!.reversed() ?? []
        } catch {
            print(error)
        }
        completion(true)
    }
}

