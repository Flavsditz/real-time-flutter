import java.util.Random;

import io.javalin.Javalin;

public class SimplePollingServer {
    public static void main(String[] args) {
        Javalin app = Javalin.create().start(8000);
        app.get("/", ctx -> ctx.result("Hello World"));
        app.get("/data", ctx -> {

            Random rand = new Random();

            if(rand.nextBoolean()){
                ctx.status(200);
                ctx.result("Some Data String");
            } else {
                ctx.status(204);
            }
        });
    }
}