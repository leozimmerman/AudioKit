//
//  AKFMOscillator.swift
//  AudioKit
//
//  Created by Aurelius Prochazka on 9/5/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

@objc class AKFMOscillator : AKParameter {
    
    var fosc = UnsafeMutablePointer<sp_fosc>.alloc(1) // allocate 1
    
    var table = AKTable()

    var frequency: Float = 440 {
        didSet {
            fosc.memory.freq = frequency
        }
    }
    
    var index: Float = 1 {
        didSet {
            fosc.memory.indx = index
        }
    }
    
    override init() {
        super.init()
        create()
    }
    
    convenience init(
        baseFrequency: AKParameter,
        carrierMultiplier: AKParameter,
        modulatingMultiplier: AKParameter,
        modulationIndex: AKParameter,
        amplitude: AKParameter)
    {
        self.init()
        baseFrequency.bind(&fosc.memory.freq)
        carrierMultiplier.bind(&fosc.memory.car)
        modulatingMultiplier.bind(&fosc.memory.mod)
        modulationIndex.bind(&fosc.memory.indx)
        amplitude.bind(&fosc.memory.amp)
    }
    
    override func create() {
        sp_fosc_create(&fosc)
        sp_fosc_init(AKManager.sharedManager.data, fosc, table.ftbl)
    }
    
    override func compute() -> Float {
        sp_fosc_compute(AKManager.sharedManager.data, fosc, nil, &value);
        pointer.memory = value
        return value
    }
    
    override func destroy() {
        sp_fosc_destroy(&fosc)
    }
    
    
}