import java.util.function.Function;

public class HigherOrderFunctions {

    // Higher-Order Function that takes a function as parameter
    public static int applyFToX(int x, Function<Integer, Integer> f) {
        return f.apply(x);
    }

    // Example function
    public static int square(int x) {
        return x * x;
    }

    public static void main(String[] args) {
        // Using named function
        assert applyFToX(4, HigherOrderFunctions::square) == 16;

        // Using anonymous function (lambda)
        assert applyFToX(4, x -> x * x) == 16;

        System.out.println("All assertions passed!");
    }
}
