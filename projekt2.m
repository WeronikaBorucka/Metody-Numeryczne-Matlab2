%PROJEKT NR.2 Weronika Borucka #5


%% zadanie 1
%sprawdzamy wiersz w-ty orginalnej macierzy z wierszem w-tym w macierzy
%zmienionej i patrzymy w którym wierszu najwiêcej elementów siê ró¿ni
clear;
format long;

%sudoku
S = [ 9 1 5 3 7 8 6 2 4;...
      6 3 4 2 9 1 8 5 7;...
      2 8 7 5 4 6 3 1 9;...
      5 6 9 8 3 7 2 4 1;...
      8 7 3 4 1 2 5 9 6;...
      4 2 1 6 5 9 7 8 3;...
      7 4 6 1 2 5 9 3 8;...
      1 5 8 9 6 3 4 7 2;...
      3 9 2 7 8 4 1 6 5];

km = zeros(1,9); %macierz liczby zmian dla wierszy macierzy  
  
for w = 1:9
       for k=1:8
            km(1,w) = abs(S(w,k)-S(w,k+1)) + km(1,w);
       end
end

[~,Imax] = max(km);

x = [1:9]-5;
y = [S(Imax,:) - 5];

X = zeros(9); %macierz x-ow przemnozona przez odpowiednie potegi
a = zeros(1,9); %macierz wspolczynnikow wielomianu
n = 8; %stopien wielomianu

for i = 1:9
    for j = 1:9
        X(i,j) = x(i)^(9-j);
    end
end

a = X\y';

a1 = polyfit(x, y, n); %sprawdzenie wspolczynnikow wielomianu W


%WYKRES WIELOMIANU
w1 = [-4:0.01:4];

%wielomian interpoluj¹cy - linia ciagla
W = polyval(a,w1);

%wykres wielomianu interpoluj¹cego
figure
plot(w1,W,'r-')
title('Interpolacja punktow wielomianem')
hold on;

%wykres punktow ktore byly interpolowane
plot(x,y,'kx')
legend('Wielomian 8go stopnia interpoluj¹cy','Interpolowane punkty', 'Location', 'best')
xlabel('x');
ylabel('y');
grid on;
hold off;

clear w1 W i j a1 wl km kz k w

%% zadanie 2

n = [8:-1:0]; %potegi wielomianu
a_transp = a';

%wielomian w postaci funkcji zaleznej tylko od x
f = @(x)  sum(a_transp .* x .^ n);

%pierwsza pochodna wielomianu f
f_poch = @(x) sum(a_transp(1:end-1) .* n(1:end-1) .* x .^ (n(1:end-1)-1));

%wyznaczenie przyblizonych miejsc wystêpowania miejsc zerowych
x_0r = roots(a);

otocz_x = x_0r + 0.1;
x_0fz = zeros(1,8);

for i = 1:size(x_0r)
    x_0fz(i) = fzero(f,otocz_x(i));
end

%wybieranie najdok³adniejszego miejsca zerowego z wyników fzero i roots
for i = 1:size(x_0r)
    if abs( f(x_0r(i)) ) >= abs( f(x_0fz(i)) )
        x0(i) = x_0fz(i);
    else
        x0(i) = x_0r(i);
    end
end

clear x_0r x_0fz i otocz_x y x X Imax

%% zadanie 3

%wybor pierwiastka najmniejszego, bliskiego zeru i najwiêkszego
min_x0 = min(x0);
mid_x0 = fzero(f,0);
max_x0 = max(x0);

 %ustalenie dok³adnosci oraz maksymalnej ilosci iteracji dla wszystkich metod
 dokl = 10^(-4);
 max_iter = 1000;

RF_x = falsi(f, min_x0 - 0.1, min_x0 + 0.1, dokl, max_iter);
 
S_x = sieczne(f, mid_x0 - 0.1, mid_x0 + 0.1, dokl, max_iter);
 
N_x = Newton(f, f_poch, max_x0 + 0.1, dokl, max_iter);
 
 clear max_iter dokl
 
 %% zadanie 4
 dokl = 10.^(-3:-1:-16);
 x_zab = zeros(size(dokl,2),6);
 max_iter = 1000;
 
 for i= 1:size(dokl,2)

     x_zab(i,1) = falsi(f, min_x0 - 0.1, min_x0 + 0.1, dokl(i), max_iter);
     x_zab(i,2) = sieczne(f, mid_x0 - 0.1, mid_x0 + 0.1, dokl(i), max_iter);
     x_zab(i,3) = Newton(f, f_poch, max_x0 + 0.1, dokl(i), max_iter);
     
     x_zab(i,4) = abs( x_zab(i,1) - min_x0);
     x_zab(i,5) = abs( x_zab(i,2) - mid_x0);
     x_zab(i,6) = abs( x_zab(i,3) - max_x0);
 end

 figure
 loglog(dokl,(x_zab(:,4))','bd-', dokl,(x_zab(:,5))','r*--', dokl,(x_zab(:,6))','ko-.')
 legend('Regula falsi', 'Metoda siecznych', 'Metoda Newtona', 'Location', 'best')
 title('Zaleznosc bledu bezwzglednego od dopuszczalnego bledu bezwzglednego w skali logarytmicznej')
 xlabel('Dopuszczalny blad bezwzgledny')
 ylabel('Blad bezwzgledny')
 axis tight
 grid on
 
 %% zadanie 5
 
dokl = 10.^(-3:-1:-16);
max_iter = 100 ;
 
 el = zeros(size(dokl,2),3);
 
  for i= 1:size(dokl,2)
         
     for j = 1:100 

         start = tic;
         falsi(f, min_x0 - 0.2, min_x0 + 0.2, dokl(i), max_iter);
         el(i,1) = el(i,1) + toc(start);

         start2 = tic;
         sieczne(f, mid_x0 - 0.2, mid_x0 + 0.2, dokl(i), max_iter);
         el(i,2) = el(i,2) + toc(start2);

         start3 = tic;
         Newton(f, f_poch, max_x0 + 0.4, dokl(i), 50);
         el(i,3) = el(i,3) + toc(start3);     
     end
     
  end
  
   figure
 loglog(dokl,el(:,1)/100,'bd-', dokl,el(:,2)/100,'r*-', dokl, el(:,3)/100,'ko-')
 legend('Regula falsi', 'Metoda siecznych', 'Metoda Newtona', 'Location', 'best')
 title('Zaleznosc czasu obliczeñ od dokladnosci w skali logarytmicznej')
 xlabel('Dopuszczalny blad bezwzgledny')
 ylabel('Usredniony czas obliczen')
 axis tight;
 grid on
 
 %% zadanie 6
 
 odl = 0.01 : 0.01 : 0.35;
 
 x_z = zeros(size(odl,2),3);

 dokl = 10^(-5);
 max_iter = 1000;
 el = zeros(size(odl,2),3);
 
 for i= 1:size(odl,2)
     
     for j = 1:100
     
     start = tic;
     x_z(i,1) = abs( falsi(f, min_x0 - odl(i), min_x0 + odl(i), dokl, max_iter) - min_x0);
     el(i,1) = el(i,1) + toc(start);
     
     start2 = tic;
     x_z(i,2) = abs( sieczne(f, mid_x0 - odl(i), mid_x0 + odl(i), dokl, max_iter) - mid_x0);
     el(i,2) = el(i,2) + toc(start2);
     
     start3 = tic;
     x_z(i,3) = abs( Newton(f, f_poch, max_x0 + odl(i), dokl, max_iter) - max_x0);
     el(i,3) = el(i,3) + toc(start3); 
     
     end
 end

 figure
 semilogy(odl,(x_z(:,1))','bd-', odl,(x_z(:,2))','r*--', odl,(x_z(:,3))','ko-.')
 legend('Regula falsi', 'Metoda siecznych', 'Metoda Newtona', 'Location', 'best')
 title('Zaleznosc bledu bezwzglednego od punktu startowego')
 xlabel('Odleglosc punktow startowych od rzeczywistego miejsca zerowego')
 ylabel('Blad bezwzgledny  w skali logarytmicznej')
 axis tight
 grid on
 
 figure
 semilogy(odl,el(:,1)/100,'bd-', odl,el(:,2)/100,'r*--', odl, el(:,3)/100,'ko-.')
 legend('Regula falsi', 'Metoda siecznych', 'Metoda Newtona', 'Location', 'best')
 title('Zaleznosc czasu obliczeñ od punktu startowego')
 xlabel('Odleglosc punktow startowych od rzeczywistego miejsca zerowego')
 ylabel('Usredniony czas obliczen w skali logarytmicznej')
 axis tight;
 grid on