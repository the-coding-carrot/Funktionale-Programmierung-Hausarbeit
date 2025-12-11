import java.util.Scanner;

public class MaybeExample {

    /**
     * Parse an Integer into a Maybe<Integer>
     */
    private static Maybe<Integer> parseMaybe(String s) {
        if (s.matches("\\d+")) {
            return Maybe.unit(Integer.parseInt(s));
        } else {
            return Maybe.nothing();
        }
    }

    /**
     * Divide numerator by denominator if it is cleanly divisible.
     * @return Just<Integer> if division is possible, Nothing if it is not
     */
    private static Maybe<Integer> divideBy(Integer numerator, Integer denominator) {
        if (denominator == 0 || numerator % denominator != 0) {
            return Maybe.nothing();
        }
        return Maybe.unit(numerator / denominator);
    }

    public static void main(String[] args) {
        System.out.println("\nExample 2: Enter a number:");
        Scanner scanner = new Scanner(System.in);
        String input = scanner.nextLine();

        /////////////////////////////////////////////////////////////////////////////

        Maybe<Integer> result2 = Maybe.unit(input)
            .bind(MaybeExample::parseMaybe)
            .map(x -> x - 2)
            .bind(x -> MaybeExample.divideBy(x, 2));

        /////////////////////////////////////////////////////////////////////////////

        if (result2.isPresent()) {
            System.out.println("Result: " + result2.getValue());
        } else {
            System.out.println("Some Error occured (use a result monad if you want to know what exactly went wrong)");
        }

        scanner.close();
    }
}
