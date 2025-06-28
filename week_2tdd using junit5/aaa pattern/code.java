class Calculator {
    public int add(int a, int b) {
        return a + b;
    }

    public int subtract(int a, int b) {
        return a - b;
    }
}

public class Main {
    private static Calculator calculator;
    public static void setUp() {
        calculator = new Calculator();
        System.out.println("Setup done.");
    }
    public static void tearDown() {
        calculator = null;
        System.out.println("Teardown done.\n");
    }
    public static void testAddition() {
        setUp();

        int result = calculator.add(5, 3);
        if (result == 8) {
            System.out.println("testAddition PASSED");
        } else {
            System.out.println("testAddition FAILED: Expected 8 but got " + result);
        }

        tearDown();
    }

    public static void testSubtraction() {
        setUp();

        int result = calculator.subtract(10, 4);
        if (result == 6) {
            System.out.println("testSubtraction PASSED");
        } else {
            System.out.println("testSubtraction FAILED: Expected 6 but got " + result);
        }

        tearDown();
    }

    public static void main(String[] args) {
        testAddition();
        testSubtraction();
    }
}
