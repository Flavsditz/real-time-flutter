import java.util.Random;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

import io.javalin.Javalin;

public class SimpleLongPollingServer {
    public static void main(String[] args) {
        Javalin app = Javalin.create().start(8000);
        app.get("/", ctx -> ctx.result("Hello Long Polling World"));
        app.get("/data", ctx -> {

            CompletableFuture.supplyAsync(SimpleLongPollingServer::simulateDataFetch)
                    .orTimeout(7, TimeUnit.SECONDS)
                    .thenApply((data) -> {
                                //In this case we got something back
                                ctx.status(200);
                                ctx.result("Some Data String and an int: " + data);
                                return null;
                            }
                    )
                    .exceptionally(throwable -> {
                        // In this case we didn't get anything before the timeout occurred
                        ctx.status(204);

                        return null;
                    }).get();
        });
    }

    public static int simulateDataFetch() {
        /**
         * In this case we are using a simple delay to simulate the server taking care of getting data,
         * however what would actually happen is that the server would be fetching for data until the timeout
         * occurs or it gets data
         */
        Random rand = new Random();
        int delaySimulation = rand.nextInt(14);

        try {
            Thread.sleep(delaySimulation * 1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        return delaySimulation;
    }
}