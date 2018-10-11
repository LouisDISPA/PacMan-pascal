PROGRAM pacman;

uses crt, sysutils;


TYPE
  Vect = RECORD
    x,y : Byte;
  END;

  TableauPos = array[0..5] of Vect; { [0] -> Pacman , [1..4] -> fantome , [5] -> cerise }

  TableauDir = array[0..4] of Byte; { 0 = pas de direction , 1 = haut , 2 = droite , 3 = bas , 4 = gauche }

  Niveau = RECORD
    tab : array[0..49,0..49] of Byte; {( mur = 0  , vide = 1 , piece = 2  , bonbon = 3 , cerise = 4 )}
    xMax, yMax : byte; { taille Max 50 sur 50 }
  END;



{ retourne vrai si il y a un fantome en [x,y] }
function fantome(pos : TableauPos; x,y : byte) : boolean;
var
  i : byte;
  fant : boolean;
begin
  fant := false;
  for i := 1 to 4 do
      if (pos[i].x = x) and (pos[i].y = y) then
        fant := true;
  fantome := fant;
end;


procedure mouvement(n : Niveau; var pos : TableauPos; var dir : TableauDir);
Begin
  {Mouvenement pacman}
  case dir[0] of
    1 : if (pos[0].y <> 0) then if (n.tab[pos[0].x ,pos[0].y - 1] <> 0) and ( not(fantome(pos, pos[0].x, pos[0].y-1)) ) then pos[0].y := pos[0].y - 1 else dir[0] := 0;
    2 : if (pos[0].x <> n.xMax-1) then if (n.tab[pos[0].x + 1 ,pos[0].y] <> 0) and ( not(fantome(pos, pos[0].x+1, pos[0].y)) ) then pos[0].x := pos[0].x + 1 else dir[0] := 0;
    3 : if (pos[0].y <> n.yMax-1) then if (n.tab[pos[0].x ,pos[0].y + 1] <> 0) and ( not(fantome(pos, pos[0].x, pos[0].y+1)) ) then pos[0].y := pos[0].y + 1 else dir[0] := 0;
    4 : if (pos[0].x <> 0) then if (n.tab[pos[0].x - 1 ,pos[0].y] <> 0) and ( not(fantome(pos, pos[0].x-1, pos[0].y)) ) then pos[0].x := pos[0].x - 1 else dir[0] := 0;
  end;


end;

procedure affichage(map : Niveau; pos : TableauPos);
var
  i,j : integer;
begin
  For i:= 1 to map.yMax-1 do
  Begin
    For j:= 1 to map.xMax-1 do
      Case map.tab[j,i] of
        0 : write('#');
        1 : write(' ');
        2 : write('.');
        3 : write('¤');
        4 : write('Q');
      End;

  end;
end;



procedure chargement(name : string; var n : Niveau;var pos : TableauPos);
var fic        : Text;
   i, j        : Integer;
   str        : string;
begin
   if (FileExists(name)) then
   begin
      assign(fic,name);
      reset(fic);
      read(fic,n.xMax);
      readln(fic,n.yMax);
      if (n.xMax > 50) or (n.yMax > 50) then
      begin
        writeln('Tailles invalides');
        halt();
      end;

      j := 0;
      while (not eof(fic)) do
      begin
       readln(fic,str);
       for i := 0 to n.xMax-1 do
          if (str[i] = '0') then
            n.tab[i][j] := 0
          else if (str[i] = '1') then
            n.tab[i][j] := 1
          else if (str[i] = '2') then
            n.tab[i][j] := 2
          else if (str[i] = '3') then
            n.tab[i][j] := 3
          else
            Writeln('erreur chargement tableau');
       j := j+1;
      end;
   end

   else
   begin
      writeln('Erreur le fichier n''existe pas');
      halt();
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
    if temps mod 5 = 0 then
    begin
      Mouvement(niv,pos,dir);
      {Interaction(niv,pos,score,vie,bonus,fin);}
      affichage(niv,pos);
    end;

    if Keypressed then
    Begin
      k := ReadKey;
      case k of
        #75 : dir[0] := 1;
        #76 : dir[0] := 2;
        #77 : dir[0] := 3;
        #78 : dir[0] := 4;
      end;
    end;

    delay(100);
    temps := temps + 1;
  end;
END.
