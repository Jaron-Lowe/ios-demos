//
//  IndexPath+ColumnBreakdown.swift
//  TicTacToe
//
//  Created by Jaron Lowe on 10/17/21.
//

import Foundation

extension IndexPath {
    
    func columnBreakdown(columnCount: Int) -> (x: Int, y: Int) {
        let y = row / columnCount
        let x = row % columnCount
        return (x: x, y: y)
    }

}
