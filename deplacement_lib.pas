unit deplacement_lib;

interface

uses type_pacman,crt;

function contact(n : Niveau; x,y : byte): boolean;
procedure avance(var n : niveau; var dir : TableauDir; i : byte);
function proxi(n : Niveau; i : byte): tableaudir;
function choisir_dir(n : Niveau; i : byte; dir : byte; pro : tableaudir ;bonus : byte): byte;
procedure mouvement(var n : Niveau; var dir : TableauDir; bonus : byte);

implementation


function contact(n : Niveau; x,y : byte): boolean;
var
  i : byte;
  con : boolean;
begin
  con := false;

  if (n.tab[x ,y] <= 1) then {si il y a un mur}
    con := true
  else
    for i := 1 to 4 do
        if (n.pos[i].x = x) and (n.pos[i].y = y) then {de fantomes}
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

function proxi(n : Niveau; i : byte): TableauDir;
var
  tab: tableaudir;
  j : byte;
begin
  for j := 0 to 4 do
    tab[j] := 0;

  if (n.pos[i].y <> 0) then {check si extrémité (inutile si il y a bien un mur sur les bordures)}
    if not(contact(n, n.pos[i].x, n.pos[i].y - 1)) then {si il n'y a pas de mur ni de porte ni de fantome}
      tab[1] := 1;

  if (n.pos[i].x <> n.xMax-1) then
    if not(contact(n, n.pos[i].x + 1, n.pos[i].y)) then
      tab[2] := 1;

  if (n.pos[i].y <> n.yMax-1) then
    if not(contact(n, n.pos[i].x ,n.pos[i].y + 1)) then
      tab[3] := 1;

  if (n.pos[i].x <> 0) then
    if not(contact(n, n.pos[i].x - 1 ,n.pos[i].y)) then
      tab[4] := 1;

  {check si pacman est autour}
  if (n.pos[i].x = n.pos[0].x) and (n.pos[i].y - 1 = n.pos[0].y) then
    tab[0] := 1

  else if (n.pos[i].x + 1 = n.pos[0].x) and (n.pos[i].y = n.pos[0].y) then
    tab[0] := 2

  else if (n.pos[i].x = n.pos[0].x) and (n.pos[i].y + 1 = n.pos[0].y) then
    tab[0] := 3

  else if (n.pos[i].x - 1 = n.pos[0].x) and (n.pos[i].y = n.pos[0].y) then
    tab[0] := 4;

  proxi := tab;
end;

function choisir_dir(n : Niveau; i : byte; dir : byte; pro : tableaudir ; bonus : byte): byte;
var
  j, sum: byte;
  rand, r, r_max, p, d_max, x, y : integer;
begin

  if dir <> 0 then {ne peut pas se retourner}
    pro[ ( (dir+1) mod 4 ) + 1 ] := 0;

  x := n.pos[0].x - n.pos[i].x; {fantome to pacman}
  y := n.pos[0].y - n.pos[i].y;
  d_max := 7 + (i-1) * 3;

  r := x*x + y*y;
  r_max := d_max * d_max;

  gotoxy(45,i);

  if  r_max > r then {si pacman est dans le champ de vision}
  begin
    p := ((r_max - r)*10) div r_max ;

    if (pro[1] <> 0) and (y < 0) then
      pro[1] := pro[1] + ((d_max*(1+p)) div(d_max-abs(x)+1));

    if (pro[2] <> 0) and (x > 0) then
      pro[2] := pro[2] + ((d_max*(1+p)) div(d_max-abs(y)+1));

    if (pro[3] <> 0) and (y > 0) then
      pro[3] := pro[3] + ((d_max*(1+p)) div(d_max-abs(x)+1));

    if (pro[4] <> 0) and (x < 0) then
      pro[4] := pro[4] + ((d_max*(1+p)) div(d_max-abs(y)+1));

    {write('R ');}

  end;

  {for j := 1 to 4 do
      write(pro[j], ' ');
    write('   ');}

  sum := 0;
  for j := 1 to 4 do
    sum := sum + pro[j];

  rand := random(sum);

  for j := 1 to 4 do
  begin
    sum := sum - pro[j];
    if sum <= rand then
      break;
  end;

  choisir_dir := j;
end;

procedure mouvement(var n : Niveau; var dir : TableauDir; bonus : byte);
var
  i: BYTE;
  pro: tableaudir;
Begin
  n.pos_pre := n.pos;
  {Mouvenement pacman}
  avance(n,dir,0);

  {Mouvement fantomes}
  for i := 1 to 4 do
  begin
    pro := proxi(n,i);

    if (bonus = 32) and (dir[i] <> 0) then
      dir[i] := ( (dir[i]+1) mod 4 ) + 1 {changemen de direction si pacman prend un bonus}
    else if pro[0] <> 0 then
      dir[i] := pro[0] {si pacman est auou alors il veu le manger}
    else if not( ( (pro[1] + pro[3] = 2) and (pro[2] + pro[4] = 0) ) or ( (pro[1] + pro[3] = 0) and (pro[2] + pro[4] = 2) ) ) or (dir[i] = 0) then{si le fantome est dans une intersection}
    begin
      dir[i] := choisir_dir(n, i, dir[i], pro, bonus); {il réflechi pour Choisir ça direction}
    end;
    avance(n,dir,i);
  end;
end;

end.
