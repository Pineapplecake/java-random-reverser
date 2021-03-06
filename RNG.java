import java.lang.reflect.Field;
import java.util.concurrent.atomic.AtomicLong;
import java.util.Random;

/**
 * Generates a test input for the seed cracker
 * Prints the result of a sequence of nextInt(int bound) calls to stdout
 * Prints the internal seed of the Random object to stderr for the user to
 * compare against the result of the seed cracker
 */
public class RNG {
    public static void main(String argv[]) throws Exception {
        Random rand = new Random();

        int bound = 256;
        int num = 8;

        // Print consecutive nextInt(int bound) outputs
        for(int i = 0; i < num; ++i) {
            System.out.println(rand.nextInt(bound));
        }

        // Get current seed
        Field seedField = Random.class.getDeclaredField("seed");
        seedField.setAccessible(true);
        long seed = ((AtomicLong)seedField.get(rand)).get();

        System.err.println("Expected seed: " + seed);
    }
}
