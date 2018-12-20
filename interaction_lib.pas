unit interaction_lib;

interface

uses crt, type_pacman, keyboard, TableauScore_lib;

procedure interaction(var n : niveau; temps : longword; var score : word; var vie : byte; var bonus : byte; var fin : byte);
procedure menu(var aventure : boolean);
procedure menu_fin(score : word; aventure : boolean; nb_niv : byte);

implementation

procedure menu_fin(score : word; aventure : boolean; nb_niv : byte);
VAR
  tab: TabScore;
  j : Joueur;
  i, pos : byte;
begin
  clrscr;
  tab := recupTabscore(aventure);

  pos := 0;

  for i := 1 to 10 do
    if tab[i].score < score then
    begin
      pos := i;
      break;
    end;

  gotoxy(1,1);

  if pos <> 0 then
  begin

    WriteLn('Bien joue ! Tu es dans les 10 meilleurs joueurs. Quel est ton nom ?');
    donekeyboard;
    ReadLn(j.nom);
    InitKeyBoard;
    j.score := score;

    clrscr;

    for i := 10 downto pos+1 do
      tab[i] := tab[i-1];
    tab[pos] := j;

    WriteLn('Voila le tableau des scores.');

    for i := 1 to 10 do
    begin
      if i = pos then
        textcolor(lightcyan)
      else
        textcolor(white);
      WriteLn(tab[i].nom, ' : ', tab[i].score);
    end;

    enregistreTabscore(tab,aventure);

  end
  else
  begin

    WriteLn('Bravos tu as fais : ', score, ' points !');
    WriteLn('Malheureusement tu n''est pas parmi les 10 meilleurs joueurs.');

    for i := 1 to 10 do
      WriteLn(tab[i].nom, ' : ', tab[i].score);

  end;

end;

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

  textcolor(lightblue);
  WriteLn('*********************************************');
  Write('*** ');
  textcolor(Yellow);
  Write('Bienvenue sur PacMan le Jeu de Pacman');
  textcolor(lightblue);
  WriteLn(' ***');
  WriteLn('*********************************************');
  WriteLn();
  WriteLn('          Choisis le mode du jeu :           ');
  WriteLn();
  textcolor(cyan);
  WriteLn('                -Aventure-                   ');
  textcolor(lightblue);
  WriteLn('                 Endurance                   ');
  WriteLn();
  WriteLn();
  textcolor(blue);
  WriteLn('Q : exit');

  repeat
    k := GetKeyEvent;

    if choix and ( (k = 50344002) or (k = 50352128) ) then
    begin
      gotoXY(17,7);
      textcolor(Lightblue);
      Write(' Aventure ');
      gotoXY(17,8);
      textcolor(cyan);
      Write('-Endurance-');
      choix := false;
    end
    else if not(choix) and ( (k = 50339393) or (k = 50350080) ) then
    begin
      gotoXY(17,7);
      textcolor(cyan);
      Write('-Aventure-');
      gotoXY(17,8);
      textcolor(Lightblue);
      Write(' Endurance ');
      choix := true;
    end;
    if k = 50335857 then
      halt;

  until (k = 50338829);

  windmaxx := 70;
  windmaxy := 70;
  clrscr;

  aventure := choix;
end;

end.
