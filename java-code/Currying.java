import java.util.function.Function;

public class Currying {

    // Non-curried version: two parameters
    public static int power(int base, int exponent) {
        return (int) Math.pow(base, exponent);
    }

    // Curried version: returns a function
    public static Function<Integer, Integer> cPower(int exponent) {
        return base -> (int) Math.pow(base, exponent);
    }

    public static void main(String[] args) {
        // Create specialized functions using currying
        Function<Integer, Integer> square = cPower(2);
        Function<Integer, Integer> cube = cPower(3);

        // Verify they produce the same results
        assert square.apply(2) == power(2, 2);
        assert cube.apply(2) == power(2, 3);

        System.out.println("square(2) = " + square.apply(2));
        System.out.println("cube(2) = " + cube.apply(2));
        System.out.println("All assertions passed!");
    }
}
