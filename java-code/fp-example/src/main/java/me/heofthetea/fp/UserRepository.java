package me.heofthetea.fp;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.sqlclient.Pool;
import io.vertx.mutiny.sqlclient.Row;
import io.vertx.mutiny.sqlclient.Tuple;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

import io.vertx.core.Future;

import java.util.Optional;
import java.util.stream.Stream;

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
     * <p>
     * Uni is vertx's version of the IO monad
     *
     * @param id The user ID to search for
     * @return A Uni containing the User, or failure if not found
     */
    public Uni<Optional<User>> getUserById(int id) {
        return client
                .preparedQuery("SELECT id, username FROM users WHERE id = $1")
                .execute(Tuple.of(id))
                .map(rowSet -> {
                    if (rowSet.size() == 0) {
                        return Optional.empty();
                    }
                    Row row = rowSet.iterator().next();
                    return Optional.of(new User(row.getInteger("id"), row.getString("username")));
                });
    }
    public Multi<User> getAllUsers() {
        return client.preparedQuery("SELECT id, username FROM users")
                     .execute()
                     .onItem()
                     .transformToMulti(rowSet -> Multi.createFrom().iterable(rowSet))
                     .map(r -> new User(r.getInteger("id"), r.getString("username")));
    }
}
