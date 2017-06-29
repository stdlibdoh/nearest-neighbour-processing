/**
 * Created by Wilson on 29/06/2017.
 */

import processing.data.*;

public class CreateInput {

    // Variable Declaration
    private Table input;                // Unprocessed table
    private int[][] matrix;             // Processed table loaded onto a 2D Array
    private int column;                 // Column number
    private int row;                    // Row number


    // Constructor
    CreateInput(Table t) {
        input = t;
        column = input.getColumnCount();
        row = input.getRowCount();
        matrix = new int[column][row];
    }

    // Methods

    // Generates the Input
    int[][] generate() {
        for(int i = 0; i < column; i++) {
            for(int j = 0; j < row; j++) {
                matrix[j][i] = input.getInt(j, i);
            }
        }
        return matrix;
    }

    // Returns the column number.
    int getSideNo() {
        return column;
    }

    // Returns the value of an individual cell
    int getWeight(int c, int r) {
        return matrix[c][r];
    }
}