//
//  Workout.swift
//  Routine
//
//  Created by Umar Qattan on 12/26/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import Foundation

class Workout: NSObject, NSCoding {

    var name:String
    var muscles:[String]
    var exercises:[Exercise]
    var date:String

    init(name: String, muscles:[String], exercises:[Exercise], date:String) {
        self.name = name
        self.muscles = muscles
        self.exercises = exercises
        self.date = date

    }

    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "workout_name") as! String
        self.muscles = aDecoder.decodeObject(forKey: "workout_muscles") as! [String]
        self.exercises = aDecoder.decodeObject(forKey: "workout_exercises") as! [Exercise]
        self.date = aDecoder.decodeObject(forKey: "workout_date") as! String

    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "workout_name")
        aCoder.encode(muscles, forKey: "workout_muscles")
        aCoder.encode(exercises, forKey: "workout_exercises")
        aCoder.encode(date, forKey: "workout_date")

    }

    override var description: String {
        return "Workout Name: \(name)\nWorkout Muscles:\(muscles)\nWorkout Exercises:\(exercises)\nWorkout Date:\(date)"
    }

}

