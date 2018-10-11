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
  END;


function contact(n : Niveau;pos : TableauPos; x,y : byte): boolean;
var
  i : byte;
  con : boolean;
begin
  con := false;

  if (n.tab[x ,y] <= 1) then {si il n'y a pas de mur ni de porte ni}
    con := true
  else
    for i := 1 to 4 do
        if (pos[i].x = x) and (pos[i].y = y) then {ni de fantomes}
          con := true;

  contact := con;
end;

procedure avance(n : niveau; var pos : TableauPos; var dir : TableauDir; i : byte);
begin
  case dir[i] of
    1 : if (pos[i].y <> 0) then {check si extrémité (inutile si il y a bien un mur sur les bordures)}
      if not(contact(n, pos, pos[i].x, pos[i].y - 1)) then {si il n'y a pas de mur ni de porte ni de fantome}
        pos[i].y := pos[i].y - 1
      else dir[i] := 0; {sinon il s'arrête}

    2 : if (pos[i].x <> n.xMax-1) then
      if not(contact(n, pos, pos[i].x + 1, pos[i].y)) then
        pos[i].x := pos[i].x + 1
      else dir[i] := 0;

    3 : if (pos[i].y <> n.yMax-1) then
      if not(contact(n, pos, pos[i].x ,pos[i].y + 1)) then
        pos[i].y := pos[i].y + 1
      else dir[i] := 0;

    4 : if (pos[i].x <> 0) then
      if not(contact(n, pos, pos[i].x - 1 ,pos[i].y)) then
        pos[i].x := pos[i].x - 1
      else dir[i] := 0;
  end;
end;

function proxi(n : Niveau; pos : TableauPos; i : byte): byte;
var
  sum: byte;
begin
  sum := 0;

  if (pos[i].y <> 0) then {check si extrémité (inutile si il y a bien un mur sur les bordures)}
    if not(contact(n, pos, pos[i].x, pos[i].y - 1)) then {si il n'y a pas de mur ni de porte ni de fantome}
      sum := sum + 1;

  if (pos[i].x <> n.xMax-1) then
    if not(contact(n, pos, pos[i].x + 1, pos[i].y)) then
      sum := sum + 1;

  if (pos[i].y <> n.yMax-1) then
    if not(contact(n, pos, pos[i].x ,pos[i].y + 1)) then
      sum := sum + 1;

  if (pos[i].x <> 0) then
    if not(contact(n, pos, pos[i].x - 1 ,pos[i].y)) then
      sum := sum + 1;

  proxi := sum;
end;

function choisir_dir(n : Niveau; pos : TableauPos; i : byte): byte;
var
  dir : byte;
begin
  dir := random(4) + 1;

  choisir_dir := dir;
end;

procedure mouvement(n : Niveau; var pos : TableauPos; var dir : TableauDir);
var
  i: BYTE;
Begin
  {Mouvenement pacman}
  avance(n,pos,dir,0);

  {Mouvement fantomes}
  for i := 1 to 4 do
  begin
    if ( dir[i] = 0 ) or ( proxi(n, pos, i) > 2 ) then {si le fantome est arreté ou qu'il est dans une intersection}
      dir[i] := choisir_dir(n, pos, i); {il réflechi pour Choisir ça direction}
      avance(n,pos,dir,i);
  end;
end;

procedure affichage(map : Niveau; pos : TableauPos);
var
  i,j : integer;
  str : STRING;
begin
  clrscr;

  {affiche le tableau}
  For i:= 0 to map.yMax-1 do
  Begin
    str := '';
    For j:= 0 to map.xMax-1 do
      Case map.tab[j,i] of
        0 : str := str + '#';
        1 : str := str + '+';
        2 : str := str + ' ';
        3 : str := str + '.';
        4 : str := str + 'o';
        5 : str := str + 'Q';
      End;
    writeln(str);
  end;

  {affiche PacMan}
  gotoXY(pos[0].x + 1,pos[0].y + 1);
  write('C');

  {affiche les fantomes}
  for i := 1 to 4 do
  begin
    gotoXY(pos[i].x + 1,pos[i].y + 1);
    write('M');
  end;
  gotoXY(1,map.yMax)
end;



procedure chargement(niv : string; var map : Niveau;var pos : TableauPos);
var
  fic : Text;
  p : byte;
  i, j : Integer;
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
        read(fic,p);
        pos[i].x := p;
        readln(fic,P);
        pos[i].y := p;
      end;

    close(fic);
   end
   else
   begin
      writeln('Erreur le fichier n''existe pas');
   end;
end;


var
  select : STRING;
  niv : Niveau;
  pos : TableauPos;
  dir : TableauDir;
  bonus, fin : boolean;
  vie : byte;
  temps : LONGINT;
  score : INTEGER;
  k : char;

BEGIN
  Randomize;
  clrscr;
  WriteLn('*********************************************');
  WriteLn('*** Bienvenue sur PacMan le Jeu de Pacman ***');
  WriteLn('*********************************************');
  WriteLn();
  WriteLn('Choisis le niveau du jeu :');
  ReadLn(select);

  if (select = '') then
    select := 'lvl1';

  chargement(select,niv,pos);
  vie := 3;
  temps := 0;
  score := 0;
  bonus := false;
  fin := false;

  affichage(niv,pos);

  delay(3000);

  while not(fin) do
  begin
    if temps mod 2 = 0 then
    begin
      Mouvement(niv,pos,dir);
      {Interaction(niv,pos,score,vie,bonus,fin);}
      affichage(niv,pos);
    end;

    if Keypressed then
    Begin
      k := ReadKey;
      case k of
        #72 : if (niv.tab[pos[0].x ,pos[0].y - 1] > 1) then dir[0] := 1; {haut}
        #77 : if (niv.tab[pos[0].x + 1 ,pos[0].y] > 1) then dir[0] := 2; {droite}
        #80 : if (niv.tab[pos[0].x ,pos[0].y + 1] > 1) then dir[0] := 3; {bas}
        #75 : if (niv.tab[pos[0].x - 1 ,pos[0].y] > 1) then dir[0] := 4; {gauche}
      end;
    end;

    delay(200);
    temps := temps + 1;
  end;
END.
