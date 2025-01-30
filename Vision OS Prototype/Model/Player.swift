//
//  Player.swift
//  Vision OS Prototype
//
//  Created by Albnor Sahiti on 16.11.24.
//
// Der Code ist eine einfache Datenstruktur, die verwendet wird, um die grundlegenden Informationen eines Schachspielers zu speichern.

struct Player {
    let name: String
    let gender: String
    let nationality: String
    let age: Int
    let aktuelleELOZahl: Int //Elo-Zahl ist eine Wertungszahl, welche die Spielstärke von Schachspielern beschreibt
    let besteELOZahl: Int
    let titel: String
    let beschreibung: String
}
