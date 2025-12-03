package me.heofthetea.fp;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.sqlclient.Pool;
import io.vertx.mutiny.sqlclient.Row;
import io.vertx.mutiny.sqlclient.Tuple;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import java.util.Optional;

/**
 * CSR Architecture - Here we communicate with the database
 * => The necessary operations that are dependent on state are moved to the bounds of the program
 */
@ApplicationScoped
public class UserRepository {

    @Inject
    Pool client;

    /**
     * Get a user with the passed id from the database
     * I/O Operation at the edge of the application
     *
     * Uni is Vert.x's IO monad - represents async computation
     * Returns Uni<Optional<User>> to handle absence without exceptions
     *
     * @param id The user ID to search for
     * @return A Uni containing Optional<User>
     */
    public Uni<Optional<User>> getUserById(int id) {
        return client
                .preparedQuery("SELECT id, username, password, age FROM users WHERE id = $1")
                .execute(Tuple.of(id))
                .map(rowSet -> {
                    if (rowSet.size() == 0) {
                        return Optional.empty();
                    }
                    Row row = rowSet.iterator().next();
                    return Optional.of(new User(
                        row.getInteger("id"),
                        row.getString("username"),
                        row.getString("password"),
                        row.getInteger("age")
                    ));
                });
    }
    public Multi<User> getAllUsers() {
        return client.preparedQuery("SELECT id, username, password, age FROM users")
                     .execute()
                     .onItem()
                     .transformToMulti(rowSet -> Multi.createFrom().iterable(rowSet))
                     .map(r -> new User(
                         r.getInteger("id"),
                         r.getString("username"),
                         r.getString("password"),
                         r.getInteger("age")
                     ));
    }
}
