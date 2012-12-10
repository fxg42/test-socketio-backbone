Proof of concept application to observe the interactions between Socket.IO,
Backbone and Express sessions.

The goal is to find out how to make Backbone Models and Collections act as views
that listen to server events. Can ajax calls be replaced by an MV* design
where the server emits events to Backbone.Model instances running on specific
clients? Is it a simpler design or not?

    Backbone.View <-[js events]-- Backbone.Model <-[socket.io events]-- Server

                                     * * *
