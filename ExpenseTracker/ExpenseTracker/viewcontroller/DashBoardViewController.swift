//
//  DashBoardTableViewController.swift
//  ExpenseTracker
//
//  Created by Tarun Tomar on 01/05/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import UIKit
import CoreData

class DashBoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var dashboardTableView: UITableView!
    @IBOutlet weak var totalExpenseAmount: UILabel!
    var fetchedData:[ExpenseLog] = []
    var availedCategory: [[String:Double]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromDb()
        dashboardTableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return availedCategory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dashboardTableView.dequeueReusableCell(withIdentifier: "dashboardCell", for: indexPath) as! DashboardCell
        let categoryData = availedCategory[indexPath.row]
        cell.categoryTitleLbl.text = categoryData.keys.first
        cell.amountLbl.text = String(categoryData.values.first!)
        cell.titleImage.image = UIImage(named: ImageName.imageNameForCategory(cell.categoryTitleLbl.text ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func fetchDataFromDb() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseLog")
            do {
                self.fetchedData = try managedContext.fetch(fetchRequest) as! [ExpenseLog]
                var expenseCount = 0.0
                for data in fetchedData {
                        expenseCount = expenseCount + data.amount
                }
                totalExpenseAmount.text = String(expenseCount)
            } catch {
                print("Error in fetching data")
    
            }
        
        var dict: [String:Double] = [:]
        for item in fetchedData {
            if dict[item.category!] != nil {
                dict[item.category!] = dict[item.category!]! + item.amount
            } else {
                dict[item.category!] = item.amount
            }
        }
        
        availedCategory = dict.map { (arg0) -> [String:Double] in
            let (k, v) = arg0
            return [k:v]
        }
    }
    
}

class DashboardCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitleLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
}
//"Donation", "Food", "Entertainment", "Health", "Shopping", "Transportation", "Utilities", "Other"


struct ImageName {
    static func imageNameForCategory(_ category: String) -> String {
        switch category {
        case "Donation":
            return "donation"
        case "Food":
            return "food"
        case "Entertainment":
            return "entertainment"
        case "Health":
            return "health"
        case "Shopping":
            return "shopping"
        case "Transportation":
            return "transportation"
        case "Utilities":
            return "utilities"
        case "Other":
            return "other"
        default:
            return "grocery"
        }
    }
}
