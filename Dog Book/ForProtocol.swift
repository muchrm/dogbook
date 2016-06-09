//
//  ForProtocol.swift
//  Development
//
//  Created by fangchanok on 8/29/2558 BE.
//  Copyright (c) 2558 fangchanok. All rights reserved.
//

import Foundation
import UIKit

protocol AgePickerDelegate {
    func didSelectValueForAge(nameAge: String, indexAge:Int)
}

protocol DatePickerDelegate {
    func didSelectValue(value: NSDate)
}

protocol ChangeMapTypeDelegate {
    func didSelectValue(value: String)
}

protocol BreedPickerDelegate {
    func didSelectValue(value: String)
}

protocol PetSelectDelegate {
    func didSelectPet(value: String)
}