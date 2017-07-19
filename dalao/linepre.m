clc,clear
ab=textread('shenzhen.txt');
y=ab(:,12);
x123=ab(:,2:4);
X=[ones(5295,1),x123];
[beta,betaint,r,rint,st]=regress(y,X);
q=sum(r.^2);
ybar=mean(y);
yhat=X*beta;
u=sum((yhat-ybar).^2);
m=3;
n=length(y);
F=u/m/(q/(n-m-1));
fw1=finv(0.025,m,n-m-1);
fw2=finv(0.975,m,n-m-1);
c=diag(inv(X'*X));
t=beta./sqrt(c)/sqrt(q/(n-m-1));
tfw=tinv(0.975,n-m-1);
save xydata y x123;


