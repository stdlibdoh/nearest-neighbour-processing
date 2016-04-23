// Global Variables
Table table;                                                                    // Variable holding the unprocessed table
CreateInput input;                                                              // Object holding the processed table
NearestNeighbour[] routes;                                                      // Array of objects holding all possible routes
Gui newGui;                                                                     // Graphical User Interface
Cell[][] newCell;                                                               // 2D Array holding each individual cell forming the GUI
PFont font;                                                                     // Text font

// Setup
void setup()
{
  size(600, 675);                                                               // Size of the window
  smooth();                                                                     // Anti-Aliasing ON
  font = loadFont("Helvetica-12.vlw");                                          // Font to be loaded
  textFont(font, 12);                                                           // Size of the font
  table = loadTable("input.csv");                                               // Unprocessed table loaded onto variable
  input = new CreateInput(table);                                               // Processed table
  routes = new NearestNeighbour[input.getSideNo()];                             // Possible routes
  for(int i = 0; i < routes.length; i++)
  {
    routes[i] = new NearestNeighbour(input.generate(), i);                      // Route generation
  }
  for(NearestNeighbour route : routes)
  {
    route.initialise();                                                         // Solving NNA for each route generated
  }
  newGui = new Gui(input.getSideNo());                                          // Graphical User interface loaded
  newCell = new Cell[input.getSideNo()][input.getSideNo()];                     // GUI Cells loaded
  for(int i = 0; i < input.getSideNo(); i++)
  {
    for(int j = 0; j < input.getSideNo(); j++)
    {
      newCell[i][j] = new Cell(i, j, input.getSideNo());
    }
  }
}

// Draw
void draw()
{
  background(255);                                                              // Sets the background
  newGui.startGui();                                                            // Generating the GUI
}

class NearestNeighbour
{
  // Variable Declaration
  int startingNode;                                                             // Initial node
  int nextNode;                                                                 // Next node to be considered
  int currentSmallest;                                                          // Holds the index of the smallest number being considered
  int totalWeight;                                                              // Total weight of the route
  boolean cont;                                                                 // Flag check for findSmallest() method
  int[][] matrix;                                                               // Loaded table
  boolean[] helperMatrix;                                                       // Row checker
  int[] path;                                                                   // Path taken
  int pathCounter = 1;                                                          // Index of path[]

  // Constructor
  NearestNeighbour (int[][] m, int i)
  {
    matrix = m;
    createHelperMatrix();
    path = new int[helperMatrix.length+1];
    path[0] = i;
    startingNode = i;
    nextNode = i;
    rowCrossing(i);
  }

  // Methods
  int initialise()                                                              // Begins the Algorithm
  {
    while (continueCheck())                                                     // Loops findSmallest() until there's only 1 value left
    {
      findSmallest(nextNode);                                                   // Runs findSmallest()
    }
    finalise();                                                                 // Runs finalise()
    totalWeight += matrix[nextNode][startingNode];                              // Updates variable with last value considered
    return(totalWeight);                                                        // Returns total weight
  }

  boolean continueCheck()                                                       // Checks if there's at least 2 values that can be
  {                                                                             // compared. If not, returns false.
    cont = true;
    if(pathCounter == path.length-2)
    {
      cont = false;
    }
    return cont;
  }

  void findSmallest(int nn)                                                     // Finds smallest number in node currently considered
  {
    for(currentSmallest = 0; currentSmallest < matrix[0].length; currentSmallest++)
    {                                                                           // Loop checking for the first accessible number and
      if(currentSmallest != nn && helperMatrix[currentSmallest])                // marking it as the smallest number
      {
        break;
      }
    }
    for(int i = currentSmallest+1; i < matrix[0].length; i++)
    {
      if(i != nn)                                                               // Checks if its an accessible position
      {
        if((matrix[i][nn] < matrix[currentSmallest][nn]) && helperMatrix[i])    // Compares the elements
        {
          currentSmallest = i;                                                  // Updates the index of the smallest value
        }
      }
      else continue;
    }
    totalWeight += matrix[currentSmallest][nn];
    nextNode = currentSmallest;
    rowCrossing(nextNode);
    path[pathCounter] = nextNode;
    pathCounter++;
  }

  void rowCrossing(int nn)                                                      // Marks a row as inaccessible after being visited
  {
    helperMatrix[nn] = false;
  }

  void createHelperMatrix()                                                     // Marks all elements of helperMatrix as no node has been
  {                                                                             // previously visited.
    helperMatrix = new boolean[matrix[0].length];
    for(int i = 0; i < helperMatrix.length; i++)
    {
      helperMatrix[i] = true;
    }
  }

  void finalise()
  {
    for(int i = 0; i < helperMatrix.length; i++)
    {
      if(helperMatrix[i])                                                       // Checks which is the last open node
      {
        helperMatrix[i] = false;
        path[pathCounter] = i;
        totalWeight += matrix[i][nextNode];
        nextNode = i;
        pathCounter++;
        path[pathCounter] = startingNode;
      }
    }
  }
}

class CreateInput
{
  // Variable Declaration
  Table input;                                                                  // Unprocessed table
  int[][] matrix;                                                               // Processed table loaded onto a 2D Array
  int column;                                                                   // Column number
  int row;                                                                      // Row number


  // Constructor
  CreateInput(Table t)
  {
    input = t;
    column = input.getColumnCount();
    row = input.getRowCount();
    matrix = new int[column][row];
  }

  // Methods
  int[][] generate()                                                            // Generates the Input
  {
    for(int i = 0; i < column; i++)
    {
      for(int j = 0; j < row; j++)
      {
        matrix[j][i] = input.getInt(j, i);                                      // Fetches value from Table class using getInt()
      }                                                                         // Stores it onto the new 2D Array
    }
    return matrix;
  }

  int getSideNo()                                                               // Returns the column number.
  {
    return column;
  }

  int getWeight(int c, int r)                                                   // Returns the value of an individual cell
  {
    return matrix[c][r];
  }
}

class Gui
{
  // Variables
  float xPos;                                                                   // Position of a cell on the X axis
  float yPos;                                                                   // Position of a cell on the Y axis
  float side;                                                                   // Length of the cell's side
  int colNo;                                                                    // Number of columns
  int nodeStart;                                                                // Starting node
  int focus;                                                                    // Colour modifier
  PVector[] buttonPos;

  // Constructor
  Gui(int cn)
  {
    colNo = cn;
    side = width/colNo;                                                         // Sets the dimension of a cell's side
    xPos = side/2;
    yPos = side/2;
    buttonPos = new PVector[colNo];
    createButtons();
  }

  // Methods
  void startGui()
  {
    createDisplay();                                                            // Creates the basic outline
    connectTheDots(detectInput());                                              // Draws the lines connecting the highlighted cells
    updateDisplay(routes[detectInput()].path);                                  // Redraws the highlighted cells
    clearInput();                                                               // Marks the un-highlighted cells
    alphaEnabled(detectInput());                                                // Marks the highlighted cells
    focus = 0;                                                                  // Resets the colour modifier
  }

  void createDisplay()                                                          // Creates the basic outline
  {
    for(int i = 0; i < colNo; i++)
    {
      for(int j = 0; j < colNo; j++)
      {
        newCell[i][j].createCell(xPos, yPos);                                   // Generates a new object of type Cell
        xPos += side;
      }
      xPos = side/2;
      yPos += side;
    }
    yPos = side/2;
    textAlign(RIGHT);
    text("Total weight of "+detectInput()+" is "+routes[detectInput()].totalWeight, width-20, height-30);
    textAlign(LEFT);
    text("Route starting at "+detectInput()+" is "+join(str(routes[detectInput()].path), ", "), 20, height-30);
  }

  void updateDisplay(int[] m)                                                   // Redraws highlighted cells
  {
    for(int i = 0; i < m.length-1; i++)
    {
      fill(90+2*focus, 76-focus, 146-0.5*focus);                                // Colour of the highlighted cell
      newCell[m[i+1]][m[i]].createCell(newCell[m[i+1]][m[i]].xPos, newCell[m[i+1]][m[i]].yPos);
      focus += 20;
    }
  }

  void clearInput()                                                             // Marks the un-highlighted cells
  {
    for(int i = 0; i < newCell[0].length; i++)
    {
      for(int j = 0; j < newCell[0].length; j++)
      {
        newCell[i][j].flag = false;                                             // Sets a cell's flag to false
      }
    }
  }

  void connectTheDots(int start)                                                // Draws the lines connecting the highlighted cells
  {
    for(int i = 0; i < routes[start].path.length-2; i++)
    {
      stroke(0);
      line(newCell[routes[start].path[i+1]][routes[start].path[i]].xPos, newCell[routes[start].path[i+1]][routes[start].path[i]].yPos, newCell[routes[start].path[i+2]][routes[start].path[i+1]].xPos, newCell[routes[start].path[i+2]][routes[start].path[i+1]].yPos);
    }
  }

  void alphaEnabled(int start)                                                  // Marks the highlighted cells
  {
    for(int i = 0; i < routes[start].path.length-1; i++)
    {
      newCell[routes[start].path[i+1]][routes[start].path[i]].flag = true;      // Sets a cell's flag to true.
    }
  }

  int detectInput()                                                             // Detects position of the mouse and assigns the
  {                                                                             // corresponding starting node to it
    for(int i = 0; i < buttonPos.length; i++)
    {
      if(checkPos(i))
      {
        nodeStart = i;
      }
    }
    return nodeStart;
  }

  boolean checkPos(int node)                                                    // Detects if mouse cursor is over a button
  {
    return mouseX > buttonPos[node].x && mouseX < buttonPos[node].x+side && mouseY > buttonPos[node].y && mouseY < buttonPos[node].y+side;
  }

  void createButtons()                                                          // Creates a positional vector storing button coordinates
  {
    for(int i = 0; i < buttonPos.length; i++)
    {
      buttonPos[i] = new PVector(i*side, i*side);
    }
  }

}

class Cell extends Gui
{
  // Variables
  int column;                                                                   // Index of column
  int row;                                                                      // Index of row
  float xPos;                                                                   // Position along the X axis
  float yPos;                                                                   // Position along the Y axis
  float side;                                                                   // Length of the cell's side
  boolean flag;                                                                 // Flag checking if the cell is highlighted or not
  float transp;                                                                 // Sets transparency of the cell

  // Constructor
  Cell(int c, int r, int cn)
  {
    super(cn);
    column = c;
    row = r;
    side = width/cn;
  }

  // Methods
  void createCell(float x, float y)                                             // Creates the cell
  {
    xPos = x;
    yPos = y;
    if(flag)                                                                    // Sets transparency by checking if cell is marked or not
    {
      transp = 255;
    }
    else
    {
      transp = 50;
      fill(255);
    }
    if(column == row && newGui.detectInput() == row)                            // Checks if a starting node is on mouseover
    {
      fill(150);                                                                // Paints a starting node as grey
    }
    rectMode(CENTER);
    stroke(0, transp);
    rect(xPos, yPos, side-5, side-5, 7);
    fill(0);
    textAlign(CENTER);
    if (column == row)  text("Starting\nNode "+column, xPos, yPos);
    else                text(input.getWeight(column, row), xPos, yPos);
  }
}