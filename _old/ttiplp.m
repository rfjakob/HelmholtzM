s = serial('com3');
fopen(s);
fprintf(s,'*IDN?');
fscanf(s)

%%
fprintf(s,'IRANGE1 1')
fprintf(s,'I1 0.1')
fprintf(s,'V1 5')

%%
fprintf(s,'OP1 1')

%%
tic
l=[];
for n=0:36
    n
    iset=sin(2*pi/36*n)*0.1+0.1;
    fprintf(s,'I1 %f\n',iset);
    fprintf(s,'I1O?');
    iact=fscanf(s,'%fA');
    pause(0.5)
    fprintf(s,'I1O?');
    iact2=fscanf(s,'%fA');
    v=[iset iact iact2]
    l=[l; v];
end
t=toc

n=linspace(0,t,length(l));
plot(n,l(:,1),'o',n,l(:,2),n,l(:,3))
legend('iset','iact','iact2')
grid on

%%
fprintf(s,'I1 %f\n',0.1);
pause(0.5)
fprintf(s,'I1 %f\n',0.12);
m=[]
for n=1:100
    n
    fprintf(s,'I1O?');
    iact=fscanf(s,'%fA');
    m=[m;iact];
end
    