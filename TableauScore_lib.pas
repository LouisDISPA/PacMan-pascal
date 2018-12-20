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

procedure enregistreTabscore(tab : TabScore; aventure : boolean);
function recupTabscore(aventure : boolean): TabScore;

implementation


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
