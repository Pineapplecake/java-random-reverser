# Java Random Reverser
This is a tool to determine the internal seed of a `java.util.Random` object from a sequence of `nextInt(int bound)` calls. This follows the approach described by [Matthew Bolan](https://www.youtube.com/channel/UCB4XuRBJZBOpnoJSWekMohw) of using a change of basis on the lattice formed by plotting consecutive seeds of `java.util.Random` to simplify the task of finding candidate seeds to finding integer points lying between minimum and maximum coordinates.
## Usage
In `random_reverser.sage`, either set `bound` to the desired value if all RNG calls use the same bound, or set the components of the `bounds` vector to the individual bounds of each RNG call if the calls use different bounds. (All bounds must be powers of two.)

Run the RNG reverser by entering the following on the command line:
```
$ sage random_reverser.sage
```
The sequence of RNG call results should be entered into the program's standard input.

The program `RNG.java` provides a sample sequence of RNG call results to be piped into the RNG cracker for testing purposes.
## Disclaimer
This program was primarily an excercise in understanding how reversing `java.util.Random` works, and is limited in its usefulness. If you need to reverse `java.util.Random` yourself, I would highly recommend [LattiCG](https://github.com/mjtb49/LattiCG) instead.
