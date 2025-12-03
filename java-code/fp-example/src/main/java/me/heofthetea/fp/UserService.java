package me.heofthetea.fp;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.NotFoundException;

@RequestScoped
public class UserService {
    @Inject
    private UserRepository userRepository;

    Uni<User> getUserById(int id) {
        return userRepository.getUserById(id).map(u -> {
            if (u.isEmpty()) {
                throw new NotFoundException("User with id " + id + " not found");
            }
            return u.get();
        });
    }

    Multi<User> getAll() {
        return userRepository.getAllUsers();
    }
}
