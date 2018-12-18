unit interaction_lib;

interface

uses crt, type_pacman, keyboard;

procedure interaction(var n : niveau; temps : longword; var score : word; var vie : byte; var bonus : byte; var fin : byte);
procedure menu(var aventure : boolean);

implementation

procedure interaction(var n : niveau; temps : longword; var score : word; var vie : byte; var bonus : byte; var fin : byte);
var
  p : vect;
  i : byte;
begin

  {si pacman à un bonus alors il diminue}
  if not(bonus = 0) then
    bonus := bonus - 1;

  {traitement de la case où est pascman}
  p := n.pos[0];
  case n.tab[p.x, p.y] of
    3 : score := score + 1;
	  4 : bonus := 32;
	  5 : vie := vie + 1;
  end;
  n.tab[p.x, p.y] := 2;


  {regarde si un fantome est sur pacman}
  for i := 1 to 4 do
    if (p.x = n.pos[i].x) and (p.y = n.pos[i].y) then
      if not(bonus = 0) then
        n.pos[i] := n.pos_start[i]
      else
        fin := 1;

  if score = n.nb_piece then
    fin := 2;

  if temps = 3*200 then
  begin
    n.tab[n.pos[5].x,n.pos[5].y] := 5;
    gotoXY(n.pos[5].x+1,n.pos[5].y+1);
    textcolor(lightred);
    write('Q');
  end;
end;


procedure menu(var aventure : boolean);
var
  choix : boolean;
  k : LONGWORD;
begin
  InitKeyBoard;
  Randomize;
  clrscr;
  cursoroff;

  choix := true;

  textcolor(Blue);
  WriteLn('*********************************************');
  Write('*** ');
  textcolor(Yellow);
  Write('Bienvenue sur PacMan le Jeu de Pacman');
  textcolor(Blue);
  WriteLn(' ***');
  WriteLn('*********************************************');
  WriteLn();
  WriteLn('          Choisis le mode du jeu :           ');
  WriteLn();
  textcolor(Lightblue);
  WriteLn('                -Aventure-                   ');
  textcolor(blue);
  WriteLn('                 Endurance                   ');

  repeat
    k := GetKeyEvent;

    if choix and ( (k = 50344002) or (k = 50352128) ) then
    begin
      gotoXY(17,7);
      textcolor(blue);
      Write(' Aventure ');
      gotoXY(17,8);
      textcolor(Lightblue);
      Write('-Endurance-');
      choix := false;
    end
    else if not(choix) and ( (k = 50339393) or (k = 50350080) ) then
    begin
      gotoXY(17,7);
      textcolor(Lightblue);
      Write('-Aventure-');
      gotoXY(17,8);
      textcolor(blue);
      Write(' Endurance ');
      choix := true;
    end

  until (k = 50338829);

  windmaxx := 70;
  windmaxy := 70;
  clrscr;

  aventure := choix;
end;

end.
