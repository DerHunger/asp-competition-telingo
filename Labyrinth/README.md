# Labyrinth

Telingo solver for the hanoi tower problem from the [ASP competition](https://www.mat.unical.it/aspcomp2013/Labyrinth)

## Usage

### Convert competition instances
*convert.asp* converts a problem instance of the competition to a more easy to understand instance

```shell
telingo convert.asp example_competition/000-labyrinth-5-0.asp
```

The converted instance will be *State 1*

### Run telingo solver on instances

```shell
telingo encoding_telingo.asp example_converted/000-labyrinth-5-0.asp
```
