PROGRAM pacman;

uses crt, keyboard, sysutils, type_pacman, Niveau_lib, deplacement_lib, interaction_lib, TableauScore_lib;

var
  niv : Niveau;
  dir : TableauDir;
  vie, fin, i, nb_niv, bonus : byte; {fin = 0 : la partie est en cours || fin = 1 : mange par un fantome || fin = 2 : manger tout les pièces}
  temps, k : LONGWORD;
  score, score_total : word;
  aventure : boolean;

BEGIN

  repeat
  
    {menu de choix du type de jeu}
    Menu(aventure);


    {initialisation des parametre de jeu et du niveau}
    nb_niv := 1;
    temps := 0;
    fin := 0;
    vie := 3;
    score := 0;
    score_total := 0;

    {boucle principale du jeu (tant que le joueur à des vies) }
    repeat

      if fin <> 1 then
        chargement('lvl' + inttostr(nb_niv),niv);

      bonus := 0;
      fin := 0;

      niv.pos := niv.pos_start;
      for i := 0 to 4 do dir[i] := 0;

      affichage_niv(niv);
      affichage_perso(niv, bonus,vie, score);

      delay(3000);

      {boucle pour 1 vie (on en sort si le joueur meurt ou gagne)}
      while fin = 0 do
      begin

        {traitement des inputs}
        while Keypressed do
          k := GetKeyEvent;

        case k of
          50339393,50350080 : if (niv.tab[niv.pos[0].x ,niv.pos[0].y - 1] > 1) then dir[0] := 1; {haut}
          50343491,50351360 : if (niv.tab[niv.pos[0].x + 1 ,niv.pos[0].y] > 1) then dir[0] := 2; {droite}
          50344002,50352128 : if (niv.tab[niv.pos[0].x ,niv.pos[0].y + 1] > 1) then dir[0] := 3; {bas}
          50339908,50350848 : if (niv.tab[niv.pos[0].x - 1 ,niv.pos[0].y] > 1) then dir[0] := 4; {gauche}
          50335857 : halt;
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

      {traitement de la cause de la fin}
    	if fin = 1 then
    	  vie := vie - 1
      else if fin = 2 then
      begin
        if aventure then
          nb_niv := nb_niv + 1;
        temps := 0;
        score_total := score_total + score;
        score := 0;
      end;

    until (vie = 0) or (nb_niv = 2);

    score_total := score_total + score;
    score := 0;

    menu_fin(score_total, aventure, nb_niv);

    k := GetKeyEvent;

  until k = 50335857;

END.
