//
//  TaskListViewController.swift
//  smartsigner
//
//  Created by Serdar Coşkun on 19.11.2019.
//  Copyright © 2019 Seneka. All rights reserved.
//

import UIKit

class FilterModel:NSObject {
    var creator:User?
    var responsive:User?
    var number:Int?
    var barcodeOrSubject:String?
    var status:TaskStatusType?
    var createdAtBegin:Date?
    var createdAtEnd:Date?
    var dueDateBegin:Date?
    var dueDateEnd:Date?
    
    func getRequestDict()->[String:Any]{
        var dict = [String:Any]()
        if let user = creator{
            dict["CreatedByUserId"] = user.id
            dict["CreatedByFilter"] = "\(user.name ?? "") \(user.surname ?? "")"
        }
        if let user = responsive{
            dict["AssignedToUserId"] = user.id
            dict["AssignedToFilter"] = "\(user.name ?? "") \(user.surname ?? "")"
        }
        
        if let number = self.number{
            dict["TaskNoteId"] = number
        }
        
        if let barcodeOrSubject = self.barcodeOrSubject{
            dict["DocumentBarcodeOrSubject"] = barcodeOrSubject
        }
        
        if let status = status{
            dict["TaskNoteStatus"] = status.rawValue
        }
        
        if let date = createdAtBegin{
            dict["CreationDateStart"] = date.toDotNet()
            dict["FilterCreationDate"] = "Range"
        }
        
        if let date = createdAtEnd{
            dict["CreationDateEnd"] = date.toDotNet()
            dict["FilterCreationDate"] = "Range"
        }
        
        if let date = dueDateBegin{
            dict["DueDateStart"] = date.toDotNet()
            dict["FilterDueDate"] = "Range"
        }
        
        if let date = dueDateEnd{
            dict["DueDateEnd"] = date.toDotNet()
            dict["FilterDueDate"] = "Range"
        }
        
        
        print("Filter: \(dict)")
        return dict
        
    }
}

class TaskListViewController: BaseViewController,TaskFilterDelegate {

    @IBOutlet weak var tableView:UITableView?
    var taskNotes:[TaskNote] = []
    var filterModel:FilterModel = FilterModel()
    
    var initialTaskId:Int?
    
    convenience init() {
        self.init(nibName: "TaskListViewController", bundle: .main)
    }
    
    override func viewDidLayoutSubviews() {
        if !didLayoutSubviews{
            didLayoutSubviews = true
            commonInit(trackingScrollView: self.tableView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.register(UINib(nibName: "TaskNoteTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        self.tableView?.backgroundColor = .tableviewBackground
        self.view.backgroundColor = .tableviewBackground
        self.tableView?.separatorStyle = .none
        self.title = LocalizedStrings.task_notes.localizedString()
        
        self.filterModel.number = self.initialTaskId
        
        fetchList()
        createFilterButton()
        
        ApiClient.get_task_note_assignment_types.execute { (_ response:GetTaskNoteAssignmentTypesResponse?, error, statusCode) in
            if let assignmentTypes = response?.assignmentTypes{
                SessionManager.current.taskNoteAssignmentTypes = assignmentTypes
            }
        }
    }
    
    func createFilterButton(){
        let barBtnFilter = UIBarButtonItem(image: UIImage(awesomeType: .filter, size: 8.0, textColor: .white), style: .done, target: self, action: #selector(showFilter))
        self.navigationItem.rightBarButtonItem = barBtnFilter
    }
    
    @objc func showFilter(){
        let vc = TaskFilterViewController(filter: self.filterModel, delegate: self)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func didApplyFilter(filter: FilterModel?) {
        if let model = filter {
            self.filterModel = model
        }else{
            self.filterModel = FilterModel()
        }
        self.taskNotes = []
        self.tableView?.reloadData()
        fetchList()
    }
    
    func fetchList(){
        ApiClient.task_list(filter:self.filterModel).execute { (_ response:GetTaskNotesResponse?, error, statusCode) in
            Utilities.processApiResponse(parentViewController: self, response: response) {
                self.taskNotes = response?.taskNotes ?? []
                print("Task Count: \(response?.taskNotes.count ?? 0)")
                self.tableView?.reloadData()
                if self.initialTaskId != nil && self.taskNotes.count > 0{
                    self.showTaskNote(note: self.taskNotes.first!)
                    
                }
            }
       }
    }
    
    func showTaskNote(note:TaskNote){
        let vc = TaskDetailViewController(note: note)
        self.navigationController?.pushViewController(vc, animated: true)
        self.initialTaskId = nil;
    }
}
extension TaskListViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskNoteTableViewCell
        cell.load(note: taskNotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.taskNotes[indexPath.row]
        showTaskNote(note: note)
    }
    
}

extension TaskListViewController:UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let minRefreshHeight:CGFloat = 180.0
        if scrollView.contentOffset.y <= -minRefreshHeight{
            self.taskNotes = []
            self.tableView?.reloadData()
            self.fetchList()
        }
    }
}
