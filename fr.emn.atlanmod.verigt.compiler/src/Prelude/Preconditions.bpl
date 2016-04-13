function well_formed(_hp: HeapType, _acc: setTable): bool
{
(
forall x: ref :: x!=null && read(_hp, x, alloc) && dtype(x)<:pacman$Grid && read(_hp, x, pacman$Grid.hasPlayer)!=null ==>
(forall y: ref :: y!=null && read(_hp, y, alloc) && dtype(y)<:pacman$Grid && x!=y ==>
!isset(_acc, y, pacman$Grid.hasPlayer)
)
)
&&
(
forall x: ref :: x!=null && read(_hp, x, alloc) && dtype(x)<:pacman$Grid && read(_hp, x, pacman$Grid.hasEnemy)!=null ==>
(forall y: ref :: y!=null && read(_hp, y, alloc) && dtype(y)<:pacman$Grid && x!=y ==>
!isset(_acc, y, pacman$Grid.hasEnemy)
)
)

}