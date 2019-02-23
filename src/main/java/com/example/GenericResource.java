package com.example;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Random;
import javax.ws.rs.core.Context;
import javax.ws.rs.Produces;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.sse.SseEventSink;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.sse.OutboundSseEvent;
import javax.ws.rs.sse.Sse;
import javax.ws.rs.sse.SseBroadcaster;

// see https://www.html5rocks.com/en/tutorials/eventsource/basics/

@Path("generic")
public class GenericResource {

    private Sse sse;
    private OutboundSseEvent.Builder eventBuilder;
    private SseBroadcaster sseBroadcaster;

    @Context
    public void setSse(Sse sse) {
        this.sse = sse;
        this.eventBuilder = sse.newEventBuilder();
        this.sseBroadcaster = sse.newBroadcaster();
    }

    private boolean running = true;

    @GET
    @Path("prices")
    @Produces(MediaType.SERVER_SENT_EVENTS)
    public void getStockPrices(@Context SseEventSink sseEventSink) {
        int lastEventId = 1;

        while (running) {
            Stock stock = getNextTransaction();
            // if (stock != null) {
            System.out.println("Send event ...");
            OutboundSseEvent sseEvent = this.eventBuilder
                    .name("stock")
                    .id(String.valueOf(lastEventId))
                    .mediaType(MediaType.APPLICATION_JSON_TYPE)
                    .data(Stock.class, stock)
                    .reconnectDelay(3000)
                    .comment("price change")
                    .build();
            sseEventSink.send(sseEvent);
            lastEventId++;
        }
        sseEventSink.close();
    }

    private Stock getNextTransaction() {
        Random r = new Random();

        try {
            Thread.sleep(3000);
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
        }

        BigDecimal price = BigDecimal.TEN.add(BigDecimal.valueOf(r.nextGaussian()));
        LocalDateTime now = LocalDateTime.now();

        return new Stock("TEST", price, now);
    }

}
