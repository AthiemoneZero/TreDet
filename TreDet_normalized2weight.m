[a,b,x1] = deal(0,1,Power);

[y1,PS] = mapminmax(x1,a,b);
plot(f,y1);
xlim([0 50]);