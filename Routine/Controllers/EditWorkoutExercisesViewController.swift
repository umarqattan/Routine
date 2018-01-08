//
//  EditWorkoutExercisesViewController.swift
//  Routine
//
//  Created by Umar Qattan on 12/30/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import UIKit

class EditWorkoutExercisesViewController: WorkoutsViewController {

    var workout:Workout!
    var selectedExercises:[String] = []
    var exercises:[Exercise] = []
    var isDoneEditingWorkout:Bool = true

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = workout.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditingWorkout))
        
        tableView.tableFooterView = UIView()
        
        for selectedExercise in selectedExercises {
            let exercise = Exercise(name: selectedExercise, weight: 0.0, sets: 0, reps: 0, notes: "Write your notes here...")
            exercises.append(exercise)
        }
        
        workout.exercises = exercises
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        exercisesEdited(workout: workout)
        tableView.reloadData()
    }
    
    @objc func doneEditingWorkout() {
        appDelegate.workouts.append(workout)
        
        let defaults = UserDefaults.standard
        let encodedWorkouts = NSKeyedArchiver.archivedData(withRootObject: appDelegate.workouts)
        defaults.set(encodedWorkouts, forKey: "Workouts")
        defaults.synchronize()
        
        dismiss(animated: true, completion: nil)
    }
    
    func exercisesEdited(workout:Workout) {
        
        for exercise in workout.exercises {
            if exercise.weight == 0 && exercise.sets == 0 && exercise.reps == 0 && exercise.notes == "Write your notes here..." {
                isDoneEditingWorkout = false
            } else {
                isDoneEditingWorkout = true
            }
        }
    
        navigationItem.rightBarButtonItem?.isEnabled = isDoneEditingWorkout
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedExercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutExerciseReuseId", for: indexPath) as! WorkoutExerciseTableViewCell
    
        
        cell.configure(exercise: exercises[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editWorkoutNewExerciseSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "editWorkoutNewExerciseSegue", let destination = segue.destination as? EditWorkoutExercisesTableViewController {
            if let indexPath = sender as? IndexPath {
                let unConfiguredExercise = exercises[indexPath.row]
                destination.exercise = unConfiguredExercise
                destination.workout = workout
            }
        }
    }
}



