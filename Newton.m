function [N_x] = Newton(f, f_poch, N_x, dokl, max_iter)

if f_poch(N_x) ~= 0 %zabezpieczenie przed dzieleniem przez 0
    
    i = 0;          %iteracja
    prev_x = N_x + 100;   %przykladowa wartosc zeby wejsc do petli

     while (abs(prev_x-N_x) >= dokl) && i <= max_iter %okreœlam dok³adnosc i zabezpieczam przed petla nieskonczona    

        prev_x = N_x;
        N_x = N_x - f(N_x)/f_poch(N_x);

        i = i+1;
     end
end