unit type_pacman;

interface

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

function symbole(a : byte): char;

implementation

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

end.
