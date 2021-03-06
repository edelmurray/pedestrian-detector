function [prediction, pred]= SVMTesting(image,model)
% [prediction maxi]
if strcmp(model.type,'binary')
    
    kerneloption.matrix=svmkernel(image,'gaussian',model.param.sigmakernel,model.xsup);
    pred = svmval(image,model.xsup,model.w,model.w0,model.param.kernel,kerneloption);
%     pred = svmval(image,model.xsup,model.w,model.w0,model.param.kernel,model.param.kerneloption);
    
    if pred>0
        prediction = 1;
    else
        prediction = -1;%0;
    end
    
else
    
    [pred, maxi] = svmmultival(image,model.xsup,model.w,model.b,model.nbsv,model.param.kernel,model.param.kerneloption);

     prediction = round(pred)-1;
    
end
    
end