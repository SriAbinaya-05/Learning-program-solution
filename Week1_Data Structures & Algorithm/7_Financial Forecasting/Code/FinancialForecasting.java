public class FinancialForecasting {

    public static double forecast(double currentValue, double growthRate, int years) {
        if (years == 0) {
            return currentValue;
        }
        return forecast(currentValue * (1 + growthRate), growthRate, years - 1);
    }

    public static double forecastMemo(double currentValue, double growthRate, int years, double[] memo) {
        if (years == 0) {
            return currentValue;
        }
        if (memo[years] != 0) {
            return memo[years];
        }
        memo[years] = forecastMemo(currentValue, growthRate, years - 1, memo) * (1 + growthRate);
        return memo[years];
    }

    public static void main(String[] args) {
        double currentValue = 10000;     
        double growthRate = 0.08;        
        int years = 5;

        System.out.println("Recursive Forecast (without memoization):");
        double futureValue = forecast(currentValue, growthRate, years);
        System.out.printf("Future Value after %d years: ₹%.2f\n", years, futureValue);

        System.out.println("\nRecursive Forecast (with memoization):");
        double[] memo = new double[years + 1];
        double futureValueMemo = forecastMemo(currentValue, growthRate, years, memo);
        System.out.printf("Future Value after %d years: ₹%.2f\n", years, futureValueMemo);
    }
}
