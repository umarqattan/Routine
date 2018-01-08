//
//  MusclesTableViewController.swift
//  Routine
//
//  Created by Umar Qattan on 1/3/18.
//  Copyright © 2018 Umar Qattan. All rights reserved.
//

import UIKit

protocol SelectMusclesDelegate: class {
    func sendSelectedMusclesToNewWorkoutTableViewController(muscles:[String])
}

class MusclesTableViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    weak var musclesDelegate:SelectMusclesDelegate? = nil
    var selectedMuscles:[String] = []
    
    let body = Body()
    
    lazy var appDelegate:AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MusclesTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return body.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "muscleReuseId", for: indexPath)
        
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = rowIsSelected ? .checkmark : .none
        cell.selectionStyle = .none
        cell.textLabel?.text = body.names[indexPath.row]
        return cell
    }
    
}

extension MusclesTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        
        selectedMuscles.append(body.names[indexPath.row])
        print(selectedMuscles)
        
        musclesDelegate?.sendSelectedMusclesToNewWorkoutTableViewController(muscles: selectedMuscles)
    
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
        
        let indexOfMuscleToRemove = selectedMuscles.index(of: body.names[indexPath.row])!
        selectedMuscles.remove(at: indexOfMuscleToRemove)
        
        musclesDelegate?.sendSelectedMusclesToNewWorkoutTableViewController(muscles: selectedMuscles)
        print(selectedMuscles)
        
    }
    
}
