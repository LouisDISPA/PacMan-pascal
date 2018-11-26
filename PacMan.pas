<<<<<<< HEAD
PROGRAM pacman;

uses crt, sysutils, type_pacman, Niveau_lib, deplacement_lib, interaction_lib;

var
  select : STRING;
  niv : Niveau;
  dir : TableauDir;
  bonus : byte;
  vie, fin, i : byte; {fin = 0 : la partie est en cours || fin = 1 : mange par un fantome || fin = 2 : manger tout les pièces}
  temps : LONGWORD;
  score : word;
  k : char;

BEGIN

  Randomize;
  clrscr;
  cursoroff;

  WriteLn('*********************************************');
  WriteLn('*** Bienvenue sur PacMan le Jeu de Pacman ***');
  WriteLn('*********************************************');
  WriteLn();
  WriteLn('Choisis le niveau du jeu :');
  ReadLn(select);

  if (select = '') then
    select := 'lvl1';

  windmaxx := 50;
  windmaxy := 50;
  clrscr;

  temps := 0;
  vie := 3;
  score := 0;
  chargement(select,niv);


  while vie <> 0 do
  begin
    bonus := 0;
    fin := 0;

    niv.pos := niv.pos_start;
    for i := 0 to 4 do dir[i] := 0;

    affichage_niv(niv);
    affichage_perso(niv, bonus,vie, score);

    delay(3000);

    while fin = 0 do
    begin

      while Keypressed do
      Begin
        k := ReadKey;
        case k of
          #72 : if (niv.tab[niv.pos[0].x ,niv.pos[0].y - 1] > 1) then dir[0] := 1; {haut}
          #77 : if (niv.tab[niv.pos[0].x + 1 ,niv.pos[0].y] > 1) then dir[0] := 2; {droite}
          #80 : if (niv.tab[niv.pos[0].x ,niv.pos[0].y + 1] > 1) then dir[0] := 3; {bas}
          #75 : if (niv.tab[niv.pos[0].x - 1 ,niv.pos[0].y] > 1) then dir[0] := 4; {gauche}
          'q' : fin := 1;
        end;
      end;

      if temps mod 3 = 0 then
      begin
        Mouvement(niv,dir,bonus);
        Interaction(niv,temps,score,vie,bonus,fin);
        affichage_perso(niv,bonus,vie,score);
      end;

      delay(100);
      temps := temps + 1;
    end;

	if fin = 1 then
	  vie := vie - 1
  else if fin = 2 then
  begin
    chargement(select,niv);
    temps := 0;
  end;

  end;
END.
=======
PROGRAM pacman;

uses crt, sysutils, type_pacman, Niveau_lib, deplacement_lib, interaction_lib;

var
  select : STRING;
  niv : Niveau;
  dir : TableauDir;
  bonus : byte;
  vie, fin, i : byte; {fin = 0 : la partie est en cours || fin = 1 : mange par un fantome || fin = 2 : manger tout les pièces}
  temps : LONGWORD;
  score : word;
  k : char;

BEGIN

  Randomize;
  clrscr;
  cursoroff;

  WriteLn('*********************************************');
  WriteLn('*** Bienvenue sur PacMan le Jeu de Pacman ***');
  WriteLn('*********************************************');
  WriteLn();
  WriteLn('Choisis le niveau du jeu :');
  ReadLn(select);

  if (select = '') then
    select := 'lvl1';

  windmaxx := 50;
  windmaxy := 50;
  clrscr;

  temps := 0;
  vie := 3;
  score := 0;
  chargement(select,niv);


  while vie <> 0 do
  begin
    bonus := 0;
    fin := 0;

    niv.pos := niv.pos_start;
    for i := 0 to 4 do dir[i] := 0;

    affichage_niv(niv);
    affichage_perso(niv, bonus,vie, score);

    delay(3000);

    while fin = 0 do
    begin

      while Keypressed do
      Begin
        k := ReadKey;
        case k of
          #72 : if (niv.tab[niv.pos[0].x ,niv.pos[0].y - 1] > 1) then dir[0] := 1; {haut}
          #77 : if (niv.tab[niv.pos[0].x + 1 ,niv.pos[0].y] > 1) then dir[0] := 2; {droite}
          #80 : if (niv.tab[niv.pos[0].x ,niv.pos[0].y + 1] > 1) then dir[0] := 3; {bas}
          #75 : if (niv.tab[niv.pos[0].x - 1 ,niv.pos[0].y] > 1) then dir[0] := 4; {gauche}
          'q' : fin := 1;
        end;
      end;

      if temps mod 3 = 0 then
      begin
        Mouvement(niv,dir,bonus);
        Interaction(niv,temps,score,vie,bonus,fin);
        affichage_perso(niv,bonus,vie,score);
      end;

      delay(100);
      temps := temps + 1;
    end;

	if fin = 1 then
	  vie := vie - 1
  else if fin = 2 then
  begin
    chargement(select,niv);
    temps := 0;
  end;

  end;
END.
>>>>>>> 53d26606cff0260d707689e884a6075b031dd3f6
