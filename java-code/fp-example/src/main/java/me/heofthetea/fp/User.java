package me.heofthetea.fp;

/**
 * Domain Model - Immutable User entity
 * Using record ensures immutability (FP principle)
 */
public record User(int id, String username, String password, int age) {

    /**
     * Always returns same result for same input (deterministic)
     *
     * @param minAge The minimum age to compare against
     * @return true if user's age is greater than minAge
     */
    public boolean isOlderThan(int minAge) {
        return age > minAge;
    }

    /**
     * Pure function: Create new User with sanitized username
     * Immutable transformation (creates new instance)
     */
    public User withSanitizedUsername() {
        String sanitized = username.trim().toLowerCase();
        return new User(id, sanitized, password, age);
    }

    /**
     * Mask Password
     */
    public User withMaskedPassword() {
        return new User(id, username, "", age);
    }
}
