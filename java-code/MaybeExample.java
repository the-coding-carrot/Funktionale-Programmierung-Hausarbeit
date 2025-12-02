import java.util.Scanner;

public class MaybeExample {

    public static void main(String[] args) {
        // Example 1: Simple chaining with valid values
        int val = 4;
        Maybe<String> result = Maybe.unit(val)
                .bind(x -> Maybe.unit(x - 2))
                .bind(x -> Maybe.unit(String.valueOf(x)));

        assert result.getValue().equals("2");
        System.out.println("Example 1 result: " + result);

        // Example 2: Handling user input that might be invalid
        System.out.println("\nExample 2: Enter a number (or non-number to see error handling):");
        Scanner scanner = new Scanner(System.in);
        String input = scanner.nextLine();

        Maybe<Integer> result2 = Maybe.unit(input)
                .bind(s -> {
                    if (s.matches("\\d+")) {
                        return Maybe.unit(Integer.parseInt(s));
                    } else {
                        return Maybe.nothing();
                    }
                })
                .bind(x -> Maybe.unit(x - 2));

        if (result2.isPresent()) {
            System.out.println("Result: " + result2.getValue());
        } else {
            System.out.println("Error: Invalid input, could not parse as number");
        }

        scanner.close();
    }
}