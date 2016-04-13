
function valid_src_model($h: HeapType): bool{


(forall __gamestate : ref ::
  (__gamestate!=null && read($h, __gamestate, alloc) && dtype(__gamestate) <: pacman$GameState ==> 
    (read($h, __gamestate, pacman$GameState.grids)!=null &&
       (forall __i: int :: 0<=__i && __i<_System.array.Length(read($h, __gamestate, pacman$GameState.grids)) ==> 
         ($Unbox(read($h, read($h, __gamestate, pacman$GameState.grids), IndexField(__i))): ref !=null 
         && read($h, $Unbox(read($h, read($h, __gamestate, pacman$GameState.grids), IndexField(__i))): ref, alloc)
         && dtype($Unbox(read($h, read($h, __gamestate, pacman$GameState.grids), IndexField(__i))): ref)<:pacman$Grid) ))
        
     &&(read($h, __gamestate, pacman$GameState.actions)!=null &&
       (forall __i: int :: 0<=__i && __i<_System.array.Length(read($h, __gamestate, pacman$GameState.actions)) ==> 
         ($Unbox(read($h, read($h, __gamestate, pacman$GameState.actions), IndexField(__i))): ref !=null 
         && read($h, $Unbox(read($h, read($h, __gamestate, pacman$GameState.actions), IndexField(__i))): ref, alloc)
         && dtype($Unbox(read($h, read($h, __gamestate, pacman$GameState.actions), IndexField(__i))): ref)<:pacman$Action) ))
        
     &&(read($h, __gamestate, pacman$GameState.player)!=null && read($h, read($h, __gamestate, pacman$GameState.player) ,alloc) ==>
       dtype(read($h, __gamestate, pacman$GameState.player)) <: pacman$Pacman ) 
     &&(read($h, __gamestate, pacman$GameState.ghost)!=null && read($h, read($h, __gamestate, pacman$GameState.ghost) ,alloc) ==>
       dtype(read($h, __gamestate, pacman$GameState.ghost)) <: pacman$Ghost ) 
     &&(read($h, __gamestate, pacman$GameState.gems)!=null &&
       (forall __i: int :: 0<=__i && __i<_System.array.Length(read($h, __gamestate, pacman$GameState.gems)) ==> 
         ($Unbox(read($h, read($h, __gamestate, pacman$GameState.gems), IndexField(__i))): ref !=null 
         && read($h, $Unbox(read($h, read($h, __gamestate, pacman$GameState.gems), IndexField(__i))): ref, alloc)
         && dtype($Unbox(read($h, read($h, __gamestate, pacman$GameState.gems), IndexField(__i))): ref)<:pacman$Gem) ))
        
     && true 
     &&(read($h, __gamestate, pacman$GameState.record)!=null && read($h, read($h, __gamestate, pacman$GameState.record) ,alloc) ==>
       dtype(read($h, __gamestate, pacman$GameState.record)) <: pacman$Record ) 
     && true 
       
  )
)

&&

(forall __pacman : ref ::
  (__pacman!=null && read($h, __pacman, alloc) && dtype(__pacman) <: pacman$Pacman ==> true
      
  )
)

&&

(forall __grid : ref ::
  (__grid!=null && read($h, __grid, alloc) && dtype(__grid) <: pacman$Grid ==> 
    (read($h, __grid, pacman$Grid.left)!=null && read($h, read($h, __grid, pacman$Grid.left) ,alloc) ==>
       dtype(read($h, __grid, pacman$Grid.left)) <: pacman$Grid ) 
     &&(read($h, __grid, pacman$Grid.right)!=null && read($h, read($h, __grid, pacman$Grid.right) ,alloc) ==>
       dtype(read($h, __grid, pacman$Grid.right)) <: pacman$Grid ) 
     &&(read($h, __grid, pacman$Grid.top)!=null && read($h, read($h, __grid, pacman$Grid.top) ,alloc) ==>
       dtype(read($h, __grid, pacman$Grid.top)) <: pacman$Grid ) 
     &&(read($h, __grid, pacman$Grid.bottom)!=null && read($h, read($h, __grid, pacman$Grid.bottom) ,alloc) ==>
       dtype(read($h, __grid, pacman$Grid.bottom)) <: pacman$Grid ) 
     &&(read($h, __grid, pacman$Grid.hasPlayer)!=null && read($h, read($h, __grid, pacman$Grid.hasPlayer) ,alloc) ==>
       dtype(read($h, __grid, pacman$Grid.hasPlayer)) <: pacman$Pacman ) 
     &&(read($h, __grid, pacman$Grid.hasEnemy)!=null && read($h, read($h, __grid, pacman$Grid.hasEnemy) ,alloc) ==>
       dtype(read($h, __grid, pacman$Grid.hasEnemy)) <: pacman$Ghost ) 
     &&(read($h, __grid, pacman$Grid.hasGem)!=null && read($h, read($h, __grid, pacman$Grid.hasGem) ,alloc) ==>
       dtype(read($h, __grid, pacman$Grid.hasGem)) <: pacman$Gem ) 
       
  )
)

&&

(forall __ghost : ref ::
  (__ghost!=null && read($h, __ghost, alloc) && dtype(__ghost) <: pacman$Ghost ==> true
      
  )
)

&&

(forall __action : ref ::
  (__action!=null && read($h, __action, alloc) && dtype(__action) <: pacman$Action ==> 
     true 
     &&(read($h, __action, pacman$Action.forPlayer)!=null && read($h, read($h, __action, pacman$Action.forPlayer) ,alloc) ==>
       dtype(read($h, __action, pacman$Action.forPlayer)) <: pacman$Pacman ) 
     && true 
     && true 
       
  )
)

&&

(forall __gem : ref ::
  (__gem!=null && read($h, __gem, alloc) && dtype(__gem) <: pacman$Gem ==> true
      
  )
)

&&

(forall __record : ref ::
  (__record!=null && read($h, __record, alloc) && dtype(__record) <: pacman$Record ==> 
     true 
     && true 
       
  )
)

} 
