package me.heofthetea.fp;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

/**
 * REST Resource - I/O Boundary
 * Handles HTTP concerns (side effect)
 * Converts between external format (HTTP) and internal domain
 *
 * Architecture:
 * HTTP (I/O) → Service (Pure Logic) → Repository (I/O)
 */
@Path("/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserResource {

    @Inject
    private UserService userService;

    /**
     * GET /users/{id}
     * Demonstrates: Converting Maybe (Optional) to HTTP response at boundary
     */
    @GET
    @Path("{id}")
    public Uni<Response> getUser(@PathParam("id") int id) {
        return userService.getUserById(id)
            .map(optUser -> optUser
                .map(user -> Response.ok(user).build())
                .orElse(Response.status(404).build()));
    }

    /**
     * GET /users/adults?age=18
     * Demonstrates filtering with pure functions using parameterized age
     *
     * @param age Minimum age for filtering (query parameter)
     * @return Multi<User> stream of users older than specified age
     */
    @GET
    @Path("/adults")
    public Multi<User> getAdultUsers(@QueryParam("age") @DefaultValue("18") int age) {
        return userService.getAdultUsers(age);
    }
}
