{   
   _x setDamage 1; 
  } forEach allPlayers select {side _x == east};

{  
   _x setDamage 1; 
  } forEach allPlayers select {side _x == west};
