public class Main {
    static class Calculator {
        public int add(int a, int b) {
            return a + b;
        }

        public int subtract(int a, int b) {
            return a - b;
        }

        public int multiply(int a, int b) {
            return a * b;
        }

        public int divide(int a, int b) {
            if (b == 0) {
                throw new IllegalArgumentException("Cannot divide by zero.");
            }
            return a / b;
        }
    }
     public static void main(String[] args) {
        Calculator calc = new Calculator();
        try {
            assertEqual("Addition", calc.add(2, 3), 5);
            assertEqual("Subtraction", calc.subtract(5, 3), 2);
            assertEqual("Multiplication", calc.multiply(3, 4), 12);
            assertEqual("Division", calc.divide(10, 2), 5);
            testDivideByZero(calc);
            System.out.println("\n All tests passed!");
        } catch (Exception e) {
            System.out.println("Test failed: " + e.getMessage());
        }
    }
    static void assertEqual(String testName, int actual, int expected) {
        if (actual != expected) {
            throw new AssertionError("Test failed - " + testName + 
                                     ": expected " + expected + ", got " + actual);
        } else {
            System.out.println("Test passed - " + testName);
        }
    }
    static void testDivideByZero(Calculator calc) {
        try {
            calc.divide(10, 0);
            throw new AssertionError("Test failed - Divide by Zero: expected exception, but none thrown.");
        } catch (IllegalArgumentException e) {
            System.out.println("Test passed - Divide by Zero (exception caught)");
        }
    }
}

