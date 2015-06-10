clear;

depth = 256; %存储器的单元数
width = 8;%数据宽度为8位

x = linspace(0,2*pi,depth);
s_sin =sin(x)*(depth-1)/2 + depth/2;%计算0 ~2*pi之间的sin值
%plot(s_sin);

fidc = fopen('sine.mif','wt');
fprintf(fidc , 'depth = %d;\n',depth);
fprintf(fidc, 'width = %d;\n',width);
fprintf(fidc, 'address_radix = UNS;\n');
fprintf(fidc,'data_radix = UNS;\n');
fprintf(fidc,'content begin\n');

for i = 1 : depth
    fprintf(fidc,'%d:%8.0f;\n',i-1,s_sin(i));
end
fprintf(fidc, 'end;');
fclose(fidc);
