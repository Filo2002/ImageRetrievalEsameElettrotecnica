function Vnew = feedback(Vr,Vsi)
        %Message
            answer = uidlg('User feedback','Rate similarity of the image you selected : ','Highly similar','More similar',...
                'Similar','Little similar','Slightly similar');
        % Handle response
        switch answer
            case 'Highly similar'     
                Wsi = 2;
            case 'More similar'
                Wsi = 1.5;
            case 'Similar'
                Wsi = 1;
            case 'Little similar'
                Wsi = 0.5;
            case 'Slightly similar'
                Wsi = 0.1;
        end
        %Calculate Vnew
        Vnew=(Wsi*Vsi+Vr)/(1+Wsi);
end