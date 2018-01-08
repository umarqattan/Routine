//
//  MusclesViewController.swift
//  Routine
//
//  Created by Umar Qattan on 12/24/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import UIKit

class MusclesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var workout:Workout?
    var selectedMuscle:Muscle!
    
    
    lazy var appDelegate:AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.title = "Exercises"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        doneButton.isEnabled = false
        selectButton.title = "Select"
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditWorkoutExercisesViewController {
            let selectedRows = tableView.indexPathsForSelectedRows
            var selectedExercises:[String] = []
            
            selectedRows?.forEach{
                let muscleNameIndex = $0.section
                let muscleName = workout!.muscles[muscleNameIndex].capitalized
                let exercises = appDelegate.muscles.filter({$0.name.capitalized == muscleName}).first!.exercises
                let exerciseName = exercises[$0.row]
                selectedExercises.append(exerciseName)
            }
            destination.selectedExercises = selectedExercises
            destination.workout = workout
        }
        
        if let destination = segue.destination as? ExercisesViewController {
           
            let selectedRows = tableView.indexPathsForSelectedRows
            var selectedExercises:[String] = []
            
            selectedRows?.forEach{
                let muscleNameIndex = $0.section
                let muscleName = workout!.muscles[muscleNameIndex].capitalized
                let exercises = appDelegate.muscles.filter({$0.name.capitalized == muscleName}).first!.exercises
                let exerciseName = exercises[$0.row]
                selectedExercises.append(exerciseName)
            }
            destination.selectedExercises = selectedExercises
            destination.workout = workout
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editWorkoutExercisesSegue", sender: self)
    }
}

extension MusclesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
        
        if let selectedRows = tableView.indexPathsForSelectedRows, selectedRows.count > 0 {
            doneButton.isEnabled = true
            selectButton.title = ""
        } else {
            doneButton.isEnabled = false
            selectButton.title = "Select"
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
        
        if let selectedRows = tableView.indexPathsForSelectedRows, selectedRows.count > 0 {
            doneButton.isEnabled = true
            selectButton.title = ""
        } else {
            doneButton.isEnabled = false
            selectButton.title = "Select"
        }
    }
    
}


extension MusclesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let workout = workout else { return 1 }
        
        return workout.muscles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let workout = workout else { return nil }
        
        return "\(workout.muscles[section].capitalized)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let workout = workout else { return appDelegate.muscles.count }
        
        let muscleName = workout.muscles[section]
        let exercises = appDelegate.muscles.filter({$0.name.capitalized == muscleName}).first!.exercises
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseReuseId", for: indexPath)
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = rowIsSelected ? .checkmark : .none
        
        let muscleName = workout!.muscles[indexPath.section].capitalized
        let exercises = appDelegate.muscles.filter({$0.name.capitalized == muscleName}).first!.exercises
        let exerciseName = exercises[indexPath.row]

        cell.selectionStyle = .none
        cell.textLabel?.text = exerciseName
    
        return cell
    }
    
    
}

