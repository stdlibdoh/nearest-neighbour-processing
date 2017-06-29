/**
 * Created by Wilson on 29/06/2017.
 */

import processing.core.*;
import processing.data.*;

public class Main extends PApplet{

    //Globals
    private CreateInput input;
    private NearestNeighbour[] routes;
    private Gui newGui;
    private Cell[][] newCell;

    public static void main(String[] args) {
        PApplet.main("Main");
    }

    public void settings() {
        size(600, 675);
        smooth();
    }

    public void setup() {
        PFont font = loadFont("Helvetica-12.vlw");
        textFont(font, 12);
        Table table = loadTable("input.csv");
        input = new CreateInput(table);
        routes = new NearestNeighbour[input.getSideNo()];
        for(int i = 0; i < routes.length; i++) {
            routes[i] = new NearestNeighbour(input.generate(), i);
        }
        for(NearestNeighbour route : routes) {
            route.initialise();
        }
        newGui = new Gui(this, input.getSideNo());
        newCell = new Cell[input.getSideNo()][input.getSideNo()];
        for(int i = 0; i < input.getSideNo(); i++) {
            for(int j = 0; j < input.getSideNo(); j++) {
                newCell[i][j] = new Cell(this, i, j, input.getSideNo());
            }
        }
    }

    public void draw() {
        background(255);
        newGui.startGui(routes, newCell, newGui, input);
    }
}