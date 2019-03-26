close all;clear all;
s = 1; ss = '';    
for Epsilon = 0:0.3:2    
    i=-1:0.001:1;
    y(s,:)=Heaviside(i,Epsilon);
    hold all;
    hnew=plot(i,y(s,:));
    ss = ['','eps=', num2str(Epsilon),''];            
    if s==1
        legend(ss,'Location','SouthEast');
    else
        [LEGH,OBJH,OUTH,OUTM] = legend;
        legend([OUTH;hnew],OUTM{:},ss,'Location','SouthEast');
    end
    s = s + 1;   
end
axis([-1 1 -0.1 1.1]);
% text(-0.7,1.05,'Heaviside Function (used eps=0)','FontWeight','bold');
% grid on;
