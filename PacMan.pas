PROGRAM pacman;

uses crt, keyboard, sysutils, type_pacman, Niveau_lib, deplacement_lib, interaction_lib;

var
  select : STRING;
  niv : Niveau;
  dir : TableauDir;
  bonus : byte;
  vie, fin, i : byte; {fin = 0 : la partie est en cours || fin = 1 : mange par un fantome || fin = 2 : manger tout les pièces}
  temps, k : LONGWORD;
  score : word;

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


  repeat
    bonus := 0;
    fin := 0;

    niv.pos := niv.pos_start;
    for i := 0 to 4 do dir[i] := 0;

    affichage_niv(niv);
    affichage_perso(niv, bonus,vie, score);

    delay(3000);

    while fin = 0 do
    begin

      while Keypressed do {traitement des inputs} { possible avec if mais moins bon}
        k := GetKeyEvent;

      case k of
        50339393 : if (niv.tab[niv.pos[0].x ,niv.pos[0].y - 1] > 1) then dir[0] := 1; {haut}
        50343491 : if (niv.tab[niv.pos[0].x + 1 ,niv.pos[0].y] > 1) then dir[0] := 2; {droite}
        50344002 : if (niv.tab[niv.pos[0].x ,niv.pos[0].y + 1] > 1) then dir[0] := 3; {bas}
        50339908 : if (niv.tab[niv.pos[0].x - 1 ,niv.pos[0].y] > 1) then dir[0] := 4; {gauche}
        50335857 : fin := 1;
      end;
      if k <> 0 then
        k := 0;

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

  until (vie = 0);

END.
