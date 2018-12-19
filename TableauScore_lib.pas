unit TableauScore_lib;

interface

uses
  crt, keyboard;

TYPE
  Joueur = RECORD
    nom : string;
    score : word;
  END;
  TabScore = ARRAY[1..10] OF Joueur;

procedure menu_fin(score : word; aventure : boolean; nb_niv : byte);
procedure enregistreTabscore(tab : TabScore; aventure : boolean);
function recupTabscore(aventure : boolean): TabScore;

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

    WriteLn('Bien joué ! Tu es dans les 10 meilleurs joueurs. Quel est ton nom ?');
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
        textcolor(Lightblue)
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

function recupTabscore(aventure : boolean): TabScore;
var
  tab : TabScore;
  f : text;
  i : byte;
  j : joueur;
begin
  if aventure then
    assign(f, 'ressource/ScoreAventure.txt')
  else
    assign(f, 'ressource/ScoreEndurance.txt');
  reset(f);

  j.nom := '---';
  j.score := 0;

  for i := 1 to 10 do
  begin
    ReadLn(f, j.nom);
    ReadLn(f, j.score);
    tab[i] := j;
  end;

  close(f);

  recupTabScore := tab;
end;

procedure enregistreTabscore(tab : TabScore; aventure : boolean);
var
  f : text;
  i : byte;
begin
  if aventure then
    assign(f, 'ressource/ScoreAventure.txt')
  else
    assign(f, 'ressource/ScoreEndurance.txt');
  rewrite(f);

  for i := 1 to 10 do
  begin
    writeln(f, tab[i].nom);
    writeln(f, tab[i].score);
  end;

  close(f);
end;
end.
