PROGRAM test;

USES
  crt, keyboard;

var
  x,y, r, r_max, p, d_max, i, j : integer;
  k : longword;
BEGIN
  InitKeyBoard;
  clrscr;

  k := GetKeyEvent;
  writeln(k);
  k := GetKeyEvent;
  writeln(k);


  for i := 1 to 21 do
  begin
    for j := 1 to 21 do
    begin
      gotoxy(i,j);

      x := i - 10; {fantome to pacman}
      y := j - 10;
      d_max := 10;

      r := x*x + y*y;
      r_max := d_max * d_max;

      if  r_max > r then {si pacman est dans le champ de vision}
      begin
        p := ((r_max - r)*9) div r_max ;

        if (y > 0) then
          write((d_max*(1+p)) div(d_max-abs(x)+1))
        else
          write('1');
      end
      else
      begin
        write('1');
      end;

    end;
  end;
END.
