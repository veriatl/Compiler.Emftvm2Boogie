type setTable = <alpha>[ref, Field alpha] bool ;
var $acc: setTable;

function isset<alpha>(H: setTable, r:ref, f:Field alpha): bool { H[r, f] }
function set<alpha>(H: setTable, r:ref, f:Field alpha, v:bool): setTable { H[r,f := v] }


function inRange(e: int, low:int, high:int):bool
{ low<=e && e<high }