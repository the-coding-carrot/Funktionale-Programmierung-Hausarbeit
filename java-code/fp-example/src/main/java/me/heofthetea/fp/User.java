package me.heofthetea.fp;

/**
 * ORM for the demo user
 * Note: This is a record type, thus immutable
 */
public record User(int id, String username){}
