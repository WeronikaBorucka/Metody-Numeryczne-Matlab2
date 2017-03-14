function [L_x] = sieczne(f, L_x, P_x, dokl, max_iter)

i = 0;          %iteracja
prev_x = L_x + 100;   %przykladowa wartosc zeby wejsc do petli

 while (abs(prev_x-L_x)> dokl) && i <= max_iter %okreœlam dok³adnosc i zabezpieczam przed petla nieskonczona    
    
    prev_x = L_x;
    
    S_x = L_x - (f(L_x)*(L_x - P_x))/(f(L_x)-f(P_x));
    
    P_x = L_x;
    L_x = S_x;
    
    i = i+1;
    
 end