//
//  AppError.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 8/19/23.
//

import Vapor

protocol AppError: AbortError, DebuggableError {}
