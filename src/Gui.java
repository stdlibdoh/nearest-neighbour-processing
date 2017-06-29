/**
 * Created by Wilson on 29/06/2017.
 */

import processing.core.*;
import java.util.Arrays;


public class Gui {
    // Variables
    private float xPos;                 // Position of a cell on the X axis
    private float yPos;                 // Position of a cell on the Y axis
    private float side;                 // Length of the cell's side
    private int colNo;                  // Number of columns
    private int nodeStart;              // Starting node
    private int focus;                  // Colour modifier
    private PVector[] buttonPos;
    private PApplet parent;

    // Constructor
    Gui(PApplet p, int cn) {
        parent = p;
        colNo = cn;
        side = parent.width/colNo;
        xPos = side/2;
        yPos = side/2;
        buttonPos = new PVector[colNo];
        createButtons();
    }

    // Methods

    void startGui(NearestNeighbour[] routes, Cell[][] newCell, Gui newGui, CreateInput input) {
        createDisplay(routes, newCell, newGui, input);
        connectTheDots(detectInput(), routes, newCell);
        updateDisplay(routes[detectInput()].path, newCell, newGui, input);
        clearInput(newCell);
        alphaEnabled(detectInput(), routes, newCell);
        focus = 0;
    }

    // Creates the basic outline
    private void createDisplay(NearestNeighbour[] routes, Cell[][] newCell, Gui newGui, CreateInput input) {
        for(int i = 0; i < colNo; i++) {
            for(int j = 0; j < colNo; j++) {
                newCell[i][j].createCell(xPos, yPos, newGui, input);
                xPos += side;
            }
            xPos = side/2;
            yPos += side;
        }
        yPos = side/2;
        parent.textAlign(parent.RIGHT);
        parent.text("Total weight of "+detectInput()+" is "+routes[detectInput()].totalWeight, parent.width-20, parent.height-30);
        parent.textAlign(parent.LEFT);
        parent.text("Route starting at "+detectInput()+" is "+Arrays.toString(routes[detectInput()].path), 20, parent.height-30);
    }

    // Redraws highlighted cells
    private void updateDisplay(int[] m, Cell[][] newCell, Gui newGui, CreateInput input) {
        for(int i = 0; i < m.length-1; i++) {
            parent.fill(90+2*focus, 76-focus, (float) (146-0.5 * focus));
            newCell[m[i+1]][m[i]].createCell(newCell[m[i+1]][m[i]].xPos, newCell[m[i+1]][m[i]].yPos, newGui, input);
            focus += 20;
        }
    }

    // Marks the un-highlighted cells
    private void clearInput(Cell[][] newCell) {
        for(int i = 0; i < newCell[0].length; i++) {
            for(int j = 0; j < newCell[0].length; j++) {
                newCell[i][j].flag = false;
            }
        }
    }

    // Draws the lines connecting the highlighted cells
    private void connectTheDots(int start, NearestNeighbour[] routes, Cell[][] newCell) {
        for(int i = 0; i < routes[start].path.length-2; i++) {
            parent.stroke(0);
            parent.line(newCell[routes[start].path[i+1]][routes[start].path[i]].xPos,
                 newCell[routes[start].path[i+1]][routes[start].path[i]].yPos,
                 newCell[routes[start].path[i+2]][routes[start].path[i+1]].xPos,
                 newCell[routes[start].path[i+2]][routes[start].path[i+1]].yPos);
        }
    }

    // Marks the highlighted cells
    private void alphaEnabled(int start, NearestNeighbour[] routes, Cell[][] newCell) {
        for(int i = 0; i < routes[start].path.length-1; i++) {
            newCell[routes[start].path[i+1]][routes[start].path[i]].flag = true;
        }
    }

    // Detects position of the mouse and assigns the corresponding starting node to it
    int detectInput() {
        for(int i = 0; i < buttonPos.length; i++) {
            if(checkPos(i))
                nodeStart = i;
        }
        return nodeStart;
    }

    // Detects if mouse cursor is over a button
    private boolean checkPos(int node) {
        return parent.mouseX > buttonPos[node].x &&
               parent.mouseX < buttonPos[node].x + side &&
               parent.mouseY > buttonPos[node].y &&
               parent.mouseY < buttonPos[node].y + side;
    }

    // Creates a positional vector storing button coordinates
    private void createButtons() {
        for(int i = 0; i < buttonPos.length; i++) {
            buttonPos[i] = new PVector(i*side, i*side);
        }
    }

}
