//
//  Validation.swift.swift
//  Code Snippets
//
//  Created by Mike Gehrke on 10.12.24.
//

import Foundation
import Firebase
import FirebaseAuth

extension String {
    // Überprüft, ob die E-Mail gültig ist
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    // Überprüft, ob das Passwort mindestens 6 Zeichen hat
    var isValidPassword: Bool {
        return self.count >= 6
    }

    // Überprüft, ob das Passwort ein Sonderzeichen enthält
    var containsSpecialCharacter: Bool {
        let specialCharacterRegex = ".*[!&^%$#@()/]+.*"
        let specialPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        return specialPredicate.evaluate(with: self)
    }

    // Überprüft, ob das Passwort mindestens eine Zahl enthält
    var containsNumber: Bool {
        return self.rangeOfCharacter(from: .decimalDigits) != nil
    }

    // Überprüft, ob das Passwort mindestens einen Großbuchstaben enthält
    var containsUppercase: Bool {
        return self.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
}
