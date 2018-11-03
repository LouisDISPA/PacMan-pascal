unit interaction_lib;

interface

uses crt, type_pacman;

procedure interaction(var n : niveau; temps : longword; var score : word; var vie : byte; var bonus : byte; var fin : byte);

implementation

procedure interaction(var n : niveau; temps : longword; var score : word; var vie : byte; var bonus : byte; var fin : byte);
var
  p : vect;
  i : byte;
begin

  if not(bonus = 0) then
    bonus := bonus - 1;

  p := n.pos[0];
  case n.tab[p.x, p.y] of
    3 : score := score + 1;
	  4 : bonus := 32;
	  5 : vie := vie + 1;
  end;
  n.tab[p.x, p.y] := 2;

  for i := 1 to 4 do
    if (p.x = n.pos[i].x) and (p.y = n.pos[i].y) then
      if not(bonus = 0) then
        n.pos[i] := n.pos_start[i]
      else
        fin := 1;

  if score mod n.nb_piece = 0 then
    fin := 2;

  if temps = 3*200 then
  begin
    n.tab[n.pos[5].x,n.pos[5].y] := 5;
    gotoXY(n.pos[5].x+1,n.pos[5].y+1);
    write('Q');
  end;
end;

end.
