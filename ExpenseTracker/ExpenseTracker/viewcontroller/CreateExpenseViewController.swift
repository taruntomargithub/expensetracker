//
//  CreateExpenseLogViewController.swift
//  ExpenseTracker
//
//  Created by Tarun Tomar on 02/05/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import UIKit
import CoreData

class CreateExpenseViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var dateTextfield: UITextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet var priceTextfield: UITextField!
    var expenseLogObj: ExpenseLog?
    var categoryArray: [String]! // Implicitly unwrapped as we pass this in segue
    var datePicker = UIDatePicker()     // make object of class UIDatePicker
    var toolBar = UIToolbar()           // make object of class UIToolbar
       
    lazy var dateFormatter: DateFormatter = {
        let dateF = DateFormatter()
        dateF.dateStyle = .medium
        dateF.timeStyle = .none
        return dateF
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextfield.delegate = self
        createDatePicker()  // Calling method to create datepicker
        createToolBar()     // Calling mrthod to create toolbar
        dateTextfield.inputView = datePicker
        dateTextfield.inputAccessoryView = toolBar
        categoryTextField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
    }
    
    @objc func myTargetFunction(textField: UITextField) {
     let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        self.categoryTextField.text = ""
        
     // 2
        for element in categoryArray {
            let categoryAction = UIAlertAction(title: element, style: .default) { (action) in
                self.categoryTextField.insertText(element)
            }
            optionMenu.addAction(categoryAction)
        }
         
     // 3
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
         
    // 4
     optionMenu.addAction(cancelAction)
         
     // 5
     self.present(optionMenu, animated: true, completion: nil)
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        dateTextfield.text = dateFormatter.string(from: datePicker.date)
    }
    

    func createToolBar() {
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayButtonPressed(sender:)))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Choose your Date"
        let labelButton = UIBarButtonItem(customView:label)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([todayButton,flexibleSpace,labelButton,flexibleSpace,doneButton], animated: true)
    }
    
    @objc func todayButtonPressed(sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter() // 1
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateTextfield.text = dateFormatter.string(from: Date()) // 2
        dateTextfield.resignFirstResponder()
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        dateTextfield.resignFirstResponder()
    }
    
    @IBAction  func onExpenseCancleButtonClick(_sender: Any) {
               dismiss(animated: true, completion: nil)
        
           }
    
    @IBAction func onExpenseSaveButtonClick(_sender: Any) {
        let name = nameTextfield.text
        let amount = Double(priceTextfield.text!)
        let category = categoryTextField.text
        let date =  dateFormatter.date(from: dateTextfield.text ?? "")
        
        
        let arrayArr: [String?] = [name,priceTextfield.text,category,dateTextfield.text]
        if isValidData(dataArray: arrayArr) {
            //Save
            createData(name: name ?? "", amount: amount ?? 0.0 , category: category ?? "", date: date ?? Date())
         showSaveAlert(msg: "Data Saved Successfully")
            //self.fetchDataFromDb()
        } else {
            //Alert that data invalid
         showSaveAlert(msg: "Please fill the all required details")
        }
    }
    
    func isValidData(dataArray: [String?]) -> Bool {
        for element in dataArray{
            if let item = element {
                if item.isEmpty {
                    //Show alert
                    return false
                }
            }
        }
        return true
    }
    
    func showSaveAlert(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
            //self.navigationController?.popViewController(animated: true)
        }
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func createData(name: String, amount: Double, category: String, date: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
            let userEntity = NSEntityDescription.entity(forEntityName: "ExpenseLog", in: managedContext)!
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(name, forKey: "name")
            user.setValue(amount, forKey: "amount")
            user.setValue(category, forKey: "category")
            user.setValue(date, forKey: "date")
        
        appDelegate.saveContext()
        fetchDataFromDb()
    }
    
        func fetchDataFromDb() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseLog")
            do {
                let fetchedData = try managedContext.fetch(fetchRequest)
                for data in fetchedData {
                    if let dataItem = data as? ExpenseLog {
                        print("Name : \(dataItem.name ?? "")")
                    }
                }
               // print(fetchedData)
            } catch {
                print("Error in fetching data")
    
            }
        }
       


}
