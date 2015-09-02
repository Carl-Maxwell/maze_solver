# Maze Generator and Solver

![screenshot of maze generator and solver](http://i.imgur.com/GeVaZQ6.png)

This projects combines a maze generator with a maze solver.

To see it in action do

```bash
ruby lib/maze_solver.rb
```

By default it'll generate a new map, but if you want to provide it with a map,
whether one you wrote or one it generated previously, just specify the
filename:

```bash
ruby lib/maze_solver.rb "mazes/maze02"
```

And watch your pathfinder search his way to ultimate victory.

When you tire of watching, use ctrl+c to exit out.

## Maze Generation

Uses [Prim's Algorithm](http://weblog.jamisbuck.org/2011/1/10/maze-generation-prim-s-algorithm)
to generate mazes.

## Pathfinding

While exploring, the pathfinder looks at the 'frontier' (unexplored tiles
adjacent to explored tiles), sorts them by how far away they are, then chooses
a goal from among them using a weighted sampling technique (such that nearer
points are more likely to be chosen).
