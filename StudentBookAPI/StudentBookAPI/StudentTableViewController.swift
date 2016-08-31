//
//  StudentTableViewController.swift
//  StudentBookAPI
//
//  Created by Justin Carver on 8/31/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    @IBOutlet weak var studentNameTextField: UITextField!
    
    var students: [Student] = [] {
        didSet {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func AddButtonTapped(sender: AnyObject) {
        guard let name = studentNameTextField.text where name != "" else { return }
        
        StudentController.sendStudent(name) { (success) in
            guard success else { return }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.studentNameTextField.text = ""
                    self.studentNameTextField.resignFirstResponder()
                    self.fetchStudent()
            })
        }
    }
    
    @IBAction func RefreshButtonTapped(sender: AnyObject) {
        fetchStudent()
    }
    
    private func fetchStudent() {
        StudentController.fetchStudents { (students) in
            self.students = students
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStudent()
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath)

        let student = students[indexPath.row]
        
        cell.textLabel?.text = student.name

        return cell
    }
}
