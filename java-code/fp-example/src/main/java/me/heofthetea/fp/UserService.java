package me.heofthetea.fp;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;

import java.util.Optional;

/**
 * Service Layer - Pure Business Logic
 * All transformations here are pure functions
 * No direct I/O - only data transformations
 *
 * Demonstrates:
 * - Monadic composition (map, flatMap)
 * - Pure functions
 * - Higher-order functions
 * - No exceptions in core logic
 */
@RequestScoped
public class UserService {
    @Inject
    private UserRepository userRepository;

    /**
     * Get user with transformations applied
     * Demonstrates functorial transformations
     */
    Uni<Optional<User>> getUserById(int id) {
        return userRepository.getUserById(id)
            .map(optUser -> optUser
                // Functorial transformations
                .map(User::withSanitizedUsername)
                .map(User::withMaskedPassword));
    }

    /**
     * Get users older than specified age
     * @param age Minimum age for filtering users
     * @return Multi<User> stream of users older than the specified age
     */
    Multi<User> getAdultUsers(int age) {
        return userRepository.getAllUsers()
            .map(User::withSanitizedUsername)
            .filter(user -> user.isOlderThan(age)) // filter is a derivative of bind
            .map(User::withMaskedPassword);
    }
}
