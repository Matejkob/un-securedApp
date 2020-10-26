//
//  CertificateHelper.swift
//  Secured App
//
//  Created by Mateusz Bąk on 25/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

struct CertificateHelper {
    
    static let themoviedb = Self.certificate(filename: "themoviedb.org", fileType: .cer)
}

private extension CertificateHelper {
    static func certificate(filename: String, fileType: CertificateFileType) -> SecCertificate? {
        guard let filePath = Bundle.main.path(forResource: filename, ofType: fileType.rawValue) else { return nil }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else { return nil }
        
        guard let certificate = SecCertificateCreateWithData(nil, data as CFData) else { return nil }
        
        return certificate
    }
}

private extension CertificateHelper {
    enum CertificateFileType: String {
        case cer
        case der
    }
}
