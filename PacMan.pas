PROGRAM pacman;

uses crt;
{
uses pacman_types_lib;
}


TYPE
  Vect = RECORD
    x,y : Byte;
  END;
]
  TableauPos = array[0..5] of Vect; { [0] -> Pacman , [1..4] -> fantome , [5] -> cerise }

  TableauDir = array[0..4] of Byte; { 0 = pas de direction , 1 = haut , 2 = droite , 3 = bas , 4 = gauche }

  Niveau = RECORD
    tab : array[0..49][0..49] of Byte; {( mur = 0  , vide = 1 , piece = 2  , bonbon = 3 , cerise = 4 )}
    xMax, yMax : byte; { taille Max 50 sur 50 }
  END;



var
  select : STRING;
  niv : Niveau;
  pos : TableauPos;
  dir : TableauDir;
  bonus : boolean;
  vie : byte;
  temps : LONGINT;
  score : INTEGER;

BEGIN
  WriteLn('*********************************************');
  WriteLn('*** Bienvenue sur PacMan le Jeu de Pacman ***');
  WriteLn('*********************************************');
  WriteLn();
  WriteLn('Choisi le niveau du jeu :');
  ReadLn(select);

  if (select = '') then
    select = 'default';

  Chargement_niveau(select,niv,pos);
  vie := 3;
  temps := 0;
  score := 0;
  bonus := false;
  fin := false;
  Affiche(niv,pos,vie);

  delay(3000);

  while not(fin) do
  begin
    Mouvement(niv,pos,dirF,dirP);
    Interaction(niv,pos,score,vie,bonus,fin);
    Affiche(niv,pos);
    temps := temps + 1;
  end;
END.
