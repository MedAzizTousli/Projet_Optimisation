%Partie 1: Optimisation sans contrainte : La régression linéaire simple
%Fonction d'erreur
function e = E(a,x,y)
M = [ones(size(x)) x];
e = norm(M*a-y)ˆ2;

%Visualisation
load partie1
a0 = -1:0.1:3;
a1 = a0;
[A0,A1]=meshgrid(a0);
for i=1:length(a0)
  for j=1:length(a1)
  a = [a0(i);a1(j)];
  ERR(i,j)=E(a,x,y);
  end
end
surf(A0,A1,ERR);
figure
contour(a0,a1,ERR,50);
%Il s'agit d'une fonction convexe. Graphiquement, le minimum existe et se situe au voisinage du point (1; 1)7

%Calcul et visualisation du champ de gradient
[Gx,Gy]=gradient(ERR);
hold on
quiver(a0,a1,Gx,Gy,2);
axis equal
%Le champ de gradient est nul au point qui réalise le minimum. Les vecteurs du champ de gradient sont orthogonaux aux courbes de niveau.

%Méthode de Newton
function [X,i] = newton(a0,A,b,eps)
% X est une matrice qui contient la trajectoires des itérations
% i est le nombre d’itérations à la fin de l’algorithme
g = A*a0-b; % Initialisation du gradient (évalué au point a0)
a1 = a0-Ang; % Calcul de la première itération (étape nécessaire pour
              % le calcul de la première valeur de l’erreur de l’algorithme)
X = a0; % stockage du premier point de la trajectoire
X = [X a1]; % stockage du deuxième point de la trajectoire
i=0;
% Coeur de l’algorithme:
while norm(a0-a1) > eps i=i+1;
  a0 = a1;
  g = A*a0-b;
  a1 = a0-Ang;
  X = [X a1]; % stockage du i-ème point de la trajectoire
end

%Méthode de gradient à pas constant
function [X,i] = pas constant(a0,A,b,rho,eps)
X = a0;
g = A*a0-b;
a1 = a0 - rho*g;
X = [X a1];
i = 0;
while norm(a1-a0) > eps
  i=i+1;
  a0 = a1;
  g = A*a0-b;
  a1 = a0 - rho*g;
  X = [X a1];
end

%Méhode de gradient à pas optimal
function [X,i] = pas optimal(a0,A,b,eps)
X = a0;
r = A*a0-b;
rho = (r’*r)/((A*r)’*r);
a1 = a0 - rho*r;
X = [X a1];
i = 0;
while norm(a1-a0) > eps
  i=i+1;
  a0 = a1;
  r = A*a0-b;
  rho = (r’*r)/((A*r)’*r);
  a1 = a0 - rho*r;
  X = [X a1];
end

%Méhode du gradient conjugué
function [X,i] = gradient conj(a0,A,b,eps)
X = a0;
r0 = A*a0-b;
d0 = r0;
rho = (r0’*r0)/((A*d0)’*d0);
a1 = a0 - rho*d0;
r1 = A*a1-b;
beta = (r1’*r1)/(r0’*r0);
d1 = r1+beta*d0;
X = [X a1];
i = 0;
while norm(a0-a1) > eps
  i=i+1;
  a0 = a1;
  d0 = d1;
  r0 = A*a0-b;
  rho = (r0’*r0)/((A*d0)’*d0);
  a1 = a0 - rho*d0;
  r1 = A*a1-b;
  beta = (r1’*r1)/(r0’*r0);
  d1 = r1+beta*d0;
  X = [X a1];
end

%Traçage des trajectoires
% On suppose qu’on a déjà affiché les courbes de niveau
% Calcul des matrices et des vecteurs du problème
M = [ones(size(x)) x];
A = M’*M;
b = M’*y;
% Choix des paramètres des algorithmes
a0 = [3;1]; % Point de départ
eps = 1e-6; % Tolérance du critère de convergence
rho = 0.01; % Le pas de gradient à pas fixe
% Calcul des trajectoires
X1 = newton(a0,A,b,eps);
X2 = pas constant(a0,A,b,rho,eps);
X3 = pas optimal(a0,A,b,eps);
X4 = gradient conj(a0,A,b,eps);
% Traçages des trajectoires
hold on
plot(X1(1,:),X1(2,:),’b’);
plot(X2(1,:),X2(2,:),’r’);
plot(X3(1,:),X3(2,:),’k’);
plot(X4(1,:),X4(2,:),’g’);
legend(’Erreur’,’Newton’,’Pas constant’,’Pas optimal’,’Gradient conjugué’)

%Traçage de la courbe du nombre d'itération en fonction du logarithme de l'erreur
load partie1
M = [ones(size(x)) x];
A = M’*M;
b = M’*y;
eps = 10.ˆ[-1:-1:-9]; % eps = [0.1 0.01 0.0001 ... 10ˆ-9];
a0 = [1.5;2.5];
rho = 0.01;
for i=1:length(eps)
e = eps(i);
  [˜,n1] = newton(a0,A,b,e); N1(i) = n1;
  [˜,n2] = pas constant(a0,A,b,rho,e); N2(i) = n2;
  [˜,n3] = pas optimal(a0,A,b,e); N3(i) = n3;
  [˜,n4] = gradient conj(a0,A,b,e); N4(i) = n4;
end
hold on
plot(-log10(eps),[N1’ N2’ N3’ N4’],’.-’)
axis([1 9 0 30])
legend(’Newton’,’Pas constant’,’Pas optimal’,’Gradient conjugué’)
yticks([1 2 5 10:5:30])
grid on
box on
%La méthode de Newton est la plus rapide(1 itération). Elle est suivie par la méthode du gradient conjugué(2 itérations)
%Le gradient à pas constant et le gradient à pas optimal sont les plus lents.

%Traçage du nuage de points et de la droite de régression
load partie1
M = [ones(size(x)) x];
A = M’*M;
b = M’*y;
eps = 1e-9;
a0 = [3;1];
a = newton(a0,A,b,eps);
a = a(:,end);
xh = [min(x) ; max(x)];
yh = a(2)*xh+a(1);
plot(x,y,’.’,’markersize’,10)
hold on
plot(xh,yh)
xlabel(’x’);
ylabel(’y’);
legend(’Nuage de points’,’Droite de régression’,’location’,’NW’)
