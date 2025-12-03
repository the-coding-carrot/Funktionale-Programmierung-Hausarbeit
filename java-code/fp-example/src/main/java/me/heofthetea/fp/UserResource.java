package me.heofthetea.fp;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;


@Path("/users")
public class UserResource {

    @Inject
    private UserService userService;

    @GET
    @Path("{id}")
    public Uni<User> getUser(@PathParam("id") int id) {
        return userService.getUserById(id);
    }

    @GET
    @Path("")
    public Multi<User> getUsers() {
        return userService.getAll();
    }

}
