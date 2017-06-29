/**
 * Created by Wilson on 29/06/2017.
 */

import processing.core.*;

public class Cell {

    // Variables
    private int column;                 // Index of column
    private int row;                    // Index of row
    float xPos;                         // Position along the X axis
    float yPos;                         // Position along the Y axis
    private float side;                 // Length of the cell's side
    boolean flag;                       // Flag checking if the cell is highlighted or not
    private PApplet parent;

    // Constructor
    Cell(PApplet p, int c, int r, int cn) {
        parent = p;
        column = c;
        row = r;
        side = parent.width/cn;
    }

    // Methods

    // Creates the cell
    void createCell(float x, float y, Gui newGui, CreateInput input) {
        float transp;
        xPos = x;
        yPos = y;
        if(flag)
            transp = 255;
        else {
            transp = 50;
            parent.fill(255);
        }
        if(column == row && newGui.detectInput() == row)
            parent.fill(150);
        parent.rectMode(parent.CENTER);
        parent.stroke(0, transp);
        parent.rect(xPos, yPos, side-5, side-5, 7);
        parent.fill(0);
        parent.textAlign(parent.CENTER);
        if (column == row)
            parent.text("Starting\nNode "+column, xPos, yPos);
        else
            parent.text(input.getWeight(column, row), xPos, yPos);
    }
}
