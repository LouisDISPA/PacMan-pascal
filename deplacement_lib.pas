<<<<<<< HEAD
unit deplacement_lib;

interface

uses type_pacman;

function contact(n : Niveau; x,y : byte): boolean;
procedure avance(var n : niveau; var dir : TableauDir; i : byte);
function proxi(n : Niveau; i : byte): byte;
function choisir_dir(n : Niveau; i : byte; bonus : byte): byte;
procedure mouvement(var n : Niveau; var dir : TableauDir; bonus : byte);
  
implementation


function contact(n : Niveau; x,y : byte): boolean;
var
  i : byte;
  con : boolean;
begin
  con := false;

  if (n.tab[x ,y] <= 1) then {si il n'y a pas de mur ni de porte ni}
    con := true
  else
    for i := 1 to 4 do
        if (n.pos[i].x = x) and (n.pos[i].y = y) then {ni de fantomes}
          con := true;

  contact := con;
end;

procedure avance(var n : niveau; var dir : TableauDir; i : byte);
begin
  case dir[i] of
    1 : if (n.pos[i].y <> 0) then {check si extrémité (inutile si il y a bien un mur sur les bordures)}
      if not(contact(n, n.pos[i].x, n.pos[i].y - 1)) then {si il n'y a pas de mur ni de porte ni de fantome}
        n.pos[i].y := n.pos[i].y - 1
      else dir[i] := 0; {sinon il s'arrête}

    2 : if (n.pos[i].x <> n.xMax-1) then
      if not(contact(n, n.pos[i].x + 1, n.pos[i].y)) then
        n.pos[i].x := n.pos[i].x + 1
      else dir[i] := 0;

    3 : if (n.pos[i].y <> n.yMax-1) then
      if not(contact(n, n.pos[i].x ,n.pos[i].y + 1)) then
        n.pos[i].y := n.pos[i].y + 1
      else dir[i] := 0;

    4 : if (n.pos[i].x <> 0) then
      if not(contact(n, n.pos[i].x - 1 ,n.pos[i].y)) then
        n.pos[i].x := n.pos[i].x - 1
      else dir[i] := 0;
  end;
end;

function proxi(n : Niveau; i : byte): byte;
var
  sum: byte;
begin
  sum := 0;

  if (n.pos[i].y <> 0) then {check si extrémité (inutile si il y a bien un mur sur les bordures)}
    if not(contact(n, n.pos[i].x, n.pos[i].y - 1)) then {si il n'y a pas de mur ni de porte ni de fantome}
      sum := sum + 1;

  if (n.pos[i].x <> n.xMax-1) then
    if not(contact(n, n.pos[i].x + 1, n.pos[i].y)) then
      sum := sum + 1;

  if (n.pos[i].y <> n.yMax-1) then
    if not(contact(n, n.pos[i].x ,n.pos[i].y + 1)) then
      sum := sum + 1;

  if (n.pos[i].x <> 0) then
    if not(contact(n, n.pos[i].x - 1 ,n.pos[i].y)) then
      sum := sum + 1;

  proxi := sum;
end;

function choisir_dir(n : Niveau; i : byte; bonus : byte): byte;
var
  dir : byte;
begin
  dir := random(4) + 1;

  choisir_dir := dir;
end;

procedure mouvement(var n : Niveau; var dir : TableauDir; bonus : byte);
var
  i: BYTE;
Begin
  n.pos_pre := n.pos;
  {Mouvenement pacman}
  avance(n,dir,0);

  {Mouvement fantomes}
  for i := 1 to 4 do
  begin
    if ( dir[i] = 0 ) or ( proxi(n, i) > 2 ) then {si le fantome est arreté ou qu'il est dans une intersection}
      dir[i] := choisir_dir(n, i, bonus); {il réflechi pour Choisir ça direction}
      avance(n,dir,i);
  end;
end;

end.
=======
unit deplacement_lib;

interface

uses type_pacman;

function contact(n : Niveau; x,y : byte): boolean;
procedure avance(var n : niveau; var dir : TableauDir; i : byte);
function proxi(n : Niveau; i : byte): byte;
function choisir_dir(n : Niveau; i : byte; bonus : byte): byte;
procedure mouvement(var n : Niveau; var dir : TableauDir; bonus : byte);
  
implementation


function contact(n : Niveau; x,y : byte): boolean;
var
  i : byte;
  con : boolean;
begin
  con := false;

  if (n.tab[x ,y] <= 1) then {si il n'y a pas de mur ni de porte ni}
    con := true
  else
    for i := 1 to 4 do
        if (n.pos[i].x = x) and (n.pos[i].y = y) then {ni de fantomes}
          con := true;

  contact := con;
end;

procedure avance(var n : niveau; var dir : TableauDir; i : byte);
begin
  case dir[i] of
    1 : if (n.pos[i].y <> 0) then {check si extrémité (inutile si il y a bien un mur sur les bordures)}
      if not(contact(n, n.pos[i].x, n.pos[i].y - 1)) then {si il n'y a pas de mur ni de porte ni de fantome}
        n.pos[i].y := n.pos[i].y - 1
      else dir[i] := 0; {sinon il s'arrête}

    2 : if (n.pos[i].x <> n.xMax-1) then
      if not(contact(n, n.pos[i].x + 1, n.pos[i].y)) then
        n.pos[i].x := n.pos[i].x + 1
      else dir[i] := 0;

    3 : if (n.pos[i].y <> n.yMax-1) then
      if not(contact(n, n.pos[i].x ,n.pos[i].y + 1)) then
        n.pos[i].y := n.pos[i].y + 1
      else dir[i] := 0;

    4 : if (n.pos[i].x <> 0) then
      if not(contact(n, n.pos[i].x - 1 ,n.pos[i].y)) then
        n.pos[i].x := n.pos[i].x - 1
      else dir[i] := 0;
  end;
end;

function proxi(n : Niveau; i : byte): byte;
var
  sum: byte;
begin
  sum := 0;

  if (n.pos[i].y <> 0) then {check si extrémité (inutile si il y a bien un mur sur les bordures)}
    if not(contact(n, n.pos[i].x, n.pos[i].y - 1)) then {si il n'y a pas de mur ni de porte ni de fantome}
      sum := sum + 1;

  if (n.pos[i].x <> n.xMax-1) then
    if not(contact(n, n.pos[i].x + 1, n.pos[i].y)) then
      sum := sum + 1;

  if (n.pos[i].y <> n.yMax-1) then
    if not(contact(n, n.pos[i].x ,n.pos[i].y + 1)) then
      sum := sum + 1;

  if (n.pos[i].x <> 0) then
    if not(contact(n, n.pos[i].x - 1 ,n.pos[i].y)) then
      sum := sum + 1;

  proxi := sum;
end;

function choisir_dir(n : Niveau; i : byte; bonus : byte): byte;
var
  dir : byte;
begin
  dir := random(4) + 1;

  choisir_dir := dir;
end;

procedure mouvement(var n : Niveau; var dir : TableauDir; bonus : byte);
var
  i: BYTE;
Begin
  n.pos_pre := n.pos;
  {Mouvenement pacman}
  avance(n,dir,0);

  {Mouvement fantomes}
  for i := 1 to 4 do
  begin
    if ( dir[i] = 0 ) or ( proxi(n, i) > 2 ) then {si le fantome est arreté ou qu'il est dans une intersection}
      dir[i] := choisir_dir(n, i, bonus); {il réflechi pour Choisir ça direction}
      avance(n,dir,i);
  end;
end;

end.
>>>>>>> 53d26606cff0260d707689e884a6075b031dd3f6
