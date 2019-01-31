# Hanoi Tower

Telingo solver for the hanoi tower problem from the [clingo guide](https://github.com/potassco/guide/releases/)


## Usage

### Convert competition instances
*convert.asp* converts a problem instance of the [ASP competition](https://www.mat.unical.it/aspcomp2013/HanoiTower) to an instance from the clingo guide

Instances from the competition have 4 pegs, which are defined as the first 4 disks and every other disk is placed on another disk.
Instances from the guide have pegs and every disk is on a peg, the order is determined by the size of each disk.
More details on the conversion can be found in the *convert.asp* file.

To convert a problem instance from the competition run the following code:

```shell
telingo convert.asp example/0004-hanoi_tower-60-0.asp
```

The converted instance will be *State 1*

### Run telingo solver on clingo guide instances

Use the *encoding_telingo.asp* on any hanoi tower instance with the same format as defined in the clingo guide.

Example:

```shell
telingo encoding_telingo.asp example_guide/0047-hanoi_tower-120-0.asp
```

### Run clingo reference solver on instances

For reference the solver from the clingo guide can be executed like this:

```shell
clingo encoding_guide.asp example_guide/0047-hanoi_tower-120-0.asp
```
