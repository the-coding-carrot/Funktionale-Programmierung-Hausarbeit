import java.util.function.Function;

public sealed interface Maybe<T> permits Maybe.Just, Maybe.Nothing {

    // unit: T -> Maybe<T>
    static <T> Maybe<T> unit(T value) {
        if (value == null) {
            return new Nothing<>();
        }
        return new Just<>(value);
    }

    // Factory method for explicit Nothing creation
    static <T> Maybe<T> nothing() {
        return new Nothing<>();
    }

    // bind: (Maybe<A>, A -> Maybe<B>) -> Maybe<B>
    <S> Maybe<S> bind(Function<T, Maybe<S>> f);

    boolean isPresent();

    T getValue() throws Exception;

    // Just represents a value that is present
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

    // Nothing represents the absence of a value
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
