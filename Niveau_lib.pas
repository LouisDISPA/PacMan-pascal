unit Niveau_lib;

interface

uses crt, sysutils, type_pacman;

procedure affichage_niv(map : Niveau);
procedure affichage_perso(n : Niveau; bonus : byte; vie :byte; score : word);
procedure chargement(niv : string; var map : Niveau);

implementation

procedure affichage_niv(map : Niveau);
var
  i,j : byte;
begin
  gotoXY(1,1);

  {affiche le tableau}
  For i:= 0 to map.yMax-1 do
  Begin
    For j:= 0 to map.xMax-1 do
      write( symbole(map.tab[j,i]) );
    writeln();
  end;
  gotoXY(1,map.yMax)
end;

procedure affichage_perso(n : Niveau; bonus : byte; vie :byte; score : word);
var
  i : byte;
begin

  {suppretion des anciennes positions}
  for i := 0 to 4 do
  begin
    gotoXY(n.pos_pre[i].x + 1,n.pos_pre[i].y + 1);
    write(symbole(n.tab[n.pos_pre[i].x,n.pos_pre[i].y]));
  end;

  {affiche PacMan}
  gotoXY(n.pos[0].x + 1,n.pos[0].y + 1);
  textcolor(Yellow);
  write('C');

  {affiche les fantomes}
  for i := 1 to 4 do
  begin
    gotoXY(n.pos[i].x + 1,n.pos[i].y + 1);

    case i of
      1 : textcolor(lightred);
      2 : textcolor(lightcyan);
      3 : textcolor(lightgreen);
      4 : textcolor(lightMagenta);
    end;

    if bonus = 0 then
      write('M')
    else
      write('Z');
  end;

  textcolor(white);

  {affiche les stats}
  gotoxy(n.xMax + 2, 2);
  write('vie : ',vie);

  gotoXY(n.xMax + 2, 4);
  write('score : ', score);

  if bonus > 1 then
  begin
    gotoXY(n.xMax + 2, 6);
    WriteLn('Bonus : ', bonus-2, ' ');
  end
  else if bonus = 1 then
  begin
    gotoXY(n.xMax + 2, 6);
    WriteLn('               ');
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
  name := 'ressource/' + niv + '.niv';
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
        map.tab[i][j] := strtoint(str[i+1]);
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


end.
