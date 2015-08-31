This is a simple pathfinding project

it is complete as an exercise but not super friendly to use.

to see it in action do

```bash
ruby lib/maze_solver.rb
```

By default it'll generate a new map, but if you want to provide it with a map,
whether one you wrote or one it generated previously, just specify the
filename:

```bash
ruby lib/maze_solver.rb "mazes/maze02"
```

and watch your pf search his way to ultimate victory.

When you tire of watching, use ctrl+c to exit out.

## Maze Generation



## Pathfinding

Looks at the 'frontier' (unexplored tiles adjacent to explored tiles)
