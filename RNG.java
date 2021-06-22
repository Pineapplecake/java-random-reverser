import java.util.Random;

public class RNG {
    public static void main(String argv[]) {
	Random seed = new Random();
	Rand rand = new Rand(seed.nextLong());

	int bits = 6;
	int num = 16;

	for(int i = 0; i < num; ++i) {
	    System.out.println(rand.nextInt(bits));
	}

	System.err.println("Expected seed: " + rand.getSeed());
    }

    static class Rand {
	private long seed;
	private long a = 25214903917L;
	private long c = 11L;
	private long m = (1L << 48) - 1;

	public Rand(long s) {
	    seed = s;
	}

	public int nextInt(int bits) {
	    seed = (a*seed + c) & m;
	    return (int)(seed >> (48 - bits));
	}

	public long getSeed() {
	    return seed;
	}

	public void setSeed(long s) {
	    seed = s & m;
	}
    }
}
