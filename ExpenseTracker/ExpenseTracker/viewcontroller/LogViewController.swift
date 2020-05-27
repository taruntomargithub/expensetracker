//
//  LogViewController.swift
//  ExpenseTracker
//
//  Created by Tarun Tomar on 01/05/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import UIKit
import CoreData

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet var orderByControl: UISegmentedControl!
    @IBOutlet var sortByControl: UISegmentedControl!
    var fetchedData:[ExpenseLog] = []
    var categoryArray: [String] = ["Donation", "Food", "Entertainment", "Health", "Shopping", "Transportation", "Utilities", "Other"]
    
    lazy var fetchedResultsController: NSFetchedResultsController<ExpenseLog> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: "ExpenseLog")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController<ExpenseLog>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logTableView.delegate = self
        logTableView.dataSource = self
       // logTableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetchDataFromDb()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in fetching from coredata : \(error.localizedDescription)")
        }
        logTableView.reloadData()
    }

    func reloadDataForCategory(_ selectedCategoryIndex: Set<Int>) {
        if selectedCategoryIndex.count == 0 {
            fetchedResultsController.fetchRequest.predicate = nil
            sort(onBasis: "date", order: false)
            return
        }
        var selectedCategories: [String] = []
        for item in selectedCategoryIndex {
            selectedCategories.append(categoryArray[item])
        }
        
        var formatString = "category == '\(selectedCategories.first!)'"
        for index in 1..<selectedCategories.count {
            formatString +=  " || " + "category == '\(selectedCategories[index])'"
        }
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: formatString)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in fetching from coredata : \(error.localizedDescription)")
        }
        logTableView.reloadData()
    }
    
    func sort(onBasis: String, order: Bool) {
        fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: onBasis, ascending: order)]
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error in fetching from coredata : \(error.localizedDescription)")
        }
        logTableView.reloadData()
    }

    @IBAction func addCategoryAction(_sender: Any) {
        performSegue(withIdentifier: "addLog", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return fetchedData.count
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = logTableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseLogCell
        if let expenceData = fetchedResultsController.fetchedObjects?[indexPath.row] {
            cell.titleLbl.text = expenceData.name
            cell.priceLbl.text = String(expenceData.amount)
            cell.titleImage.image = UIImage(named: ImageName.imageNameForCategory(expenceData.category ?? ""))
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func configureCell(_ cell: UITableViewCell, at: IndexPath) {
        // Update cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Category" {
            if let destination = segue.destination as? CategoryCollectionViewController {
                destination.dataArray = categoryArray
                destination.observer = reloadDataForCategory(_:)
            }
        } else if segue.identifier == "addLog" {
            if let destination = segue.destination as? CreateExpenseViewController {
                destination.categoryArray = categoryArray
            }
            
        }
    }

}

extension LogViewController  : NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    logTableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
      if let indexPath = newIndexPath {
        logTableView.insertRows(at: [indexPath], with: .fade)
      }
      break;
    case .delete:
      if let indexPath = indexPath {
        logTableView.deleteRows(at: [indexPath], with: .fade)
      }
      break;
    case .update:
      if let indexPath = indexPath, let cell = logTableView.cellForRow(at: indexPath) {
        configureCell(cell, at: indexPath)
      }
      break;
      
    case .move:
      if let indexPath = indexPath {
        logTableView.deleteRows(at: [indexPath], with: .fade)
      }
      
      if let newIndexPath = newIndexPath {
        logTableView.insertRows(at: [newIndexPath], with: .fade)
      }
      break;
      
    @unknown default:
        fatalError()
    }
}
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    logTableView.endUpdates()
  }
    
    @IBAction func orderBySegmentControl(_ sender: Any) {
        switch orderByControl.selectedSegmentIndex
        {
        case 0: sort(onBasis: "date", order: false)
            
        case 1: sort(onBasis: "date", order: true)
            
        default:
            break
        }
    }
    @IBAction func sortBySegmentControl(_ sender: Any) {
        switch sortByControl.selectedSegmentIndex
        {
        case 0: sort(onBasis: "date", order: false)

        case 1: sort(onBasis: "amount", order: false)

        default:
            break
        }
    }
}

class ExpenseLogCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
}
