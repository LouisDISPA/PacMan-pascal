PROGRAM pacman;

uses crt, sysutils;


TYPE
  Vect = RECORD
    x,y : Byte;
  END;

  TableauPos = array[0..5] of Vect; { [0] -> Pacman , [1..4] -> fantome , [5] -> cerise }

  TableauDir = array[0..4] of Byte; { 0 = pas de direction , 1 = haut , 2 = droite , 3 = bas , 4 = gauche }

  Niveau = RECORD
    tab : array[0..49,0..49] of Byte; {( mur = 0  , porte = 1 , vide = 2 , piece = 3  , bonbon = 4 , Cerise = 5)}
    xMax, yMax : byte; { taille Max 50 sur 50 }
    pos_start, pos_pre, pos : tableauPos;
    nb_piece : word;
  END;


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

function symbole(a : byte): char;
begin
  Case a of
    0 : symbole := '#';
    1 : symbole := '+';
    2 : symbole := ' ';
    3 : symbole := '.';
    4 : symbole := 'o';
    5 : symbole := 'Q';
  end;
end;

procedure affichage_niv(map : Niveau);
var
  i,j : byte;
  str : STRING;
begin
  gotoXY(1,1);

  {affiche le tableau}
  For i:= 0 to map.yMax-1 do
  Begin
    str := '';
    For j:= 0 to map.xMax-1 do
      str := str + symbole(map.tab[j,i]);
    writeln(str);
  end;
  gotoXY(1,map.yMax)
end;

procedure affichage_perso(n : Niveau; bonus : byte);
var
  i : byte;
begin

  {affiche PacMan}
  for i := 0 to 4 do
  begin
    gotoXY(n.pos_pre[i].x + 1,n.pos_pre[i].y + 1);
    write(symbole(n.tab[n.pos_pre[i].x,n.pos_pre[i].y]));
  end;

  gotoXY(n.pos[0].x + 1,n.pos[0].y + 1);
  write('C');

  {affiche les fantomes}
  for i := 1 to 4 do
  begin
    gotoXY(n.pos[i].x + 1,n.pos[i].y + 1);
    if bonus = 0 then
      write('M')
    else
      write('Z');
  end;

  gotoXY(1,n.yMax);

end;


procedure chargement(niv : string; var map : Niveau);
var
  fic : Text;
  p : word;
  i, j : byte;
  str, name : string;
begin
  name := niv + '.niv';
   if (FileExists(name)) then
   begin

    assign(fic,name);
    reset(fic);
    read(fic,map.xMax);
    readln(fic,map.yMax);
    if (map.xMax > 50) or (map.yMax > 50) then
    begin
      writeln('Tailles invalides');
    end;

    for j := 0 to map.yMax-1 do
    begin
     readln(fic,str);
     for i := 0 to map.xMax-1 do
        if (str[i+1] = '0') then
          map.tab[i][j] := 0
        else if (str[i+1] = '1') then
          map.tab[i][j] := 1
        else if (str[i+1] = '2') then
          map.tab[i][j] := 2
        else if (str[i+1] = '3') then
          map.tab[i][j] := 3
        else if (str[i+1] = '4') then
          map.tab[i][j] := 4
        else
          Write('erreur chargement tableau  ');
    end;

    for i := 0 to 5 do
    begin
      read(fic,j);
      map.pos_start[i].x := j;
      readln(fic,j);
      map.pos_start[i].y := j;
    end;

    read(fic,p);
    map.nb_piece := p;

    close(fic);
  end
  else
    writeln('Erreur le fichier n''existe pas');
end;


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
	  4 : bonus := 30;
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
    affichage_perso(niv, bonus);

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
        affichage_perso(niv,bonus);
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
