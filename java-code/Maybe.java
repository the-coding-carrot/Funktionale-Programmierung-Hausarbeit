import java.util.function.Function;


/**
 * Simple implementation of a Maybe Monad to go along with the Functional Programming
 * SWE Presentation and Seminar thesis.
 */
public sealed interface Maybe<T> permits Maybe.Just, Maybe.Nothing {

    /**
     * unit: T -> Maybe<T>
     */
    static <T> Maybe<T> unit(T value) {
        if (value == null) {
            return new Nothing<>();
        }
        return new Just<>(value);
    }

    /**
     * bind: (Maybe<A>, A -> Maybe<B>) -> Maybe<B>
     */
    <S> Maybe<S> bind(Function<T, Maybe<S>> f);

    //
    /**
     * map: (Maybe<A>, A -> B) -> Maybe<B>
     *
     * Derived from bind and unit
     */
    default <S> Maybe<S> map(Function<T, S> f) {
        return bind(value -> Maybe.unit(f.apply(value)));
    }

    //////////////////// more utility methods ///////////////////////////////////

    // Factory method for explicit Nothing creation
    static <T> Maybe<T> nothing() {
        return new Nothing<>();
    }

    // Provide a default value if Nothing
    default T orElse(T defaultValue) {
        return this instanceof Maybe.Just<T> ? this.getValue() : defaultValue;
    }

    boolean isPresent();

    T getValue();

    /**
     * The Just variant represents that a value is present
     */
    final class Just<T> implements Maybe<T> {
        private final T value;

        private Just(T value) {
            this.value = value;
        }

        @Override
        public <S> Maybe<S> bind(Function<T, Maybe<S>> f) {
            return f.apply(this.value);
        }

        @Override
        public boolean isPresent() {
            return true;
        }

        @Override
        public T getValue() {
            return value;
        }

        @Override
        public String toString() {
            return "Just(" + value + ")";
        }
    }

    // The Nothing variant represents the absence of the value
    final class Nothing<T> implements Maybe<T> {

        private Nothing() {
        }

        @Override
        public <S> Maybe<S> bind(Function<T, Maybe<S>> f) {
            return new Nothing<>();
        }

        @Override
        public boolean isPresent() {
            return false;
        }

        @Override
        public T getValue() {
            throw new IllegalStateException("Cannot get value from Nothing");
        }

        @Override
        public String toString() {
            return "Nothing";
        }
    }
}
