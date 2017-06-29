/**
 * Created by Wilson on 29/06/2017.
 */

public class NearestNeighbour {

    // Variable Declaration
    private int startingNode;           // Initial node
    private int nextNode;               // Next node to be considered
    int totalWeight;                    // Total weight of the route
    private int[][] matrix;             // Loaded table
    private boolean[] helperMatrix;     // Row checker
    int[] path;                         // Path taken
    private int pathCounter = 1;        // Index of path[]

    // Constructor
    NearestNeighbour (int[][] m, int i) {
        matrix = m;
        createHelperMatrix();
        path = new int[helperMatrix.length+1];
        path[0] = i;
        startingNode = i;
        nextNode = i;
        rowCrossing(i);
    }

    // Methods

    // Begins the Algorithm
    void initialise() {
        while (continueCheck()) {
            findSmallest(nextNode);
        }
        finalise();
        totalWeight += matrix[nextNode][startingNode];
    }

    // Checks if there's at least 2 values that can be compared. If not, returns false.
    private boolean continueCheck() {
        boolean cont = true;
        if(pathCounter == path.length-2)
            cont = false;
        return cont;
    }

    // Finds smallest number in node currently considered
    private void findSmallest(int nn) {
        int currentSmallest;
        for(currentSmallest = 0; currentSmallest < matrix[0].length; currentSmallest++) {
            if(currentSmallest != nn && helperMatrix[currentSmallest])
                break;
        }
        for(int i = currentSmallest+1; i < matrix[0].length; i++) {
            if(i != nn) {
                if ((matrix[i][nn] < matrix[currentSmallest][nn]) && helperMatrix[i])
                    currentSmallest = i;
            }
        }
        totalWeight += matrix[currentSmallest][nn];
        nextNode = currentSmallest;
        rowCrossing(nextNode);
        path[pathCounter] = nextNode;
        pathCounter++;
    }

    // Marks a row as inaccessible after being visited
    private void rowCrossing(int nn) {
        helperMatrix[nn] = false;
    }

    // Marks all elements of helperMatrix as no node has been
    private void createHelperMatrix() {
        helperMatrix = new boolean[matrix[0].length];
        for(int i = 0; i < helperMatrix.length; i++) {
            helperMatrix[i] = true;
        }
    }

    private void finalise() {
        for(int i = 0; i < helperMatrix.length; i++) {
            if(helperMatrix[i]) {
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
