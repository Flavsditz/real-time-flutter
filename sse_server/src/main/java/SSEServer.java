import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

import io.javalin.Javalin;
import io.javalin.http.sse.SseClient;

public class SSEServer {

    public static void main(String[] args) throws InterruptedException {
        Queue<SseClient> clients = new ConcurrentLinkedQueue<SseClient>();

        Javalin app = Javalin.create().start(8000);
        app.get("/", ctx -> ctx.result("Hello Long Polling World"));
        app.sse("/sse", client -> {
            clients.add(client);
            client.sendEvent("connected", "Hello, SSE");
            client.onClose(() -> {
                System.out.println("Client Disconnected");
                clients.remove(client);
            });
        });

        while (true) {
            for (SseClient client : clients) {
                client.sendEvent("SimpleEvent", "PING");
            }
            Thread.sleep(5000);
        }

    }
}