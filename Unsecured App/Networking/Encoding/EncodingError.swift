//
//  EncodingError.swift
//  NetworkingLayer
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 x-kom. All rights reserved.
//

import Foundation

enum EncodingError: String, Error {
	case parametersNil = "Parameters were nil."
	case encodingFailed = "Parameter encoding failed."
	case missingURL = "URL is nil."
}
