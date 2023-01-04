classdef designImageRetrieval < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        QualearrayButtonGroup          matlab.ui.container.ButtonGroup
        SelfAttVecButton               matlab.ui.control.RadioButton
        SimilarityImageButton          matlab.ui.control.RadioButton
        popupmenu_NumOfReturnedImages  matlab.ui.control.DropDown
        CercaButton                    matlab.ui.control.Button
        ImmaginecaricataPanel          matlab.ui.container.Panel
        ImmaginiDatabasePanel          matlab.ui.container.Panel
        Image_39                       matlab.ui.control.Image
        Image_38                       matlab.ui.control.Image
        Image_37                       matlab.ui.control.Image
        Image_35                       matlab.ui.control.Image
        Image_34                       matlab.ui.control.Image
        Image_33                       matlab.ui.control.Image
        Image_31                       matlab.ui.control.Image
        Image_30                       matlab.ui.control.Image
        Image_29                       matlab.ui.control.Image
        Image_27                       matlab.ui.control.Image
        Image_26                       matlab.ui.control.Image
        Image_25                       matlab.ui.control.Image
        Image_23                       matlab.ui.control.Image
        Image_22                       matlab.ui.control.Image
        Image_21                       matlab.ui.control.Image
        Image_19                       matlab.ui.control.Image
        Image_18                       matlab.ui.control.Image
        Image_17                       matlab.ui.control.Image
        Image_15                       matlab.ui.control.Image
        Image_14                       matlab.ui.control.Image
        Image_13                       matlab.ui.control.Image
        Image_11                       matlab.ui.control.Image
        Image_10                       matlab.ui.control.Image
        Image                          matlab.ui.control.Image
        btn_ricercaImmagini            matlab.ui.control.Button
        ImmaginiSimiliPanel            matlab.ui.container.Panel
        MarianiFilippoRoselliPaoloPetrosilliMarcoLabel  matlab.ui.control.Label
        Label                          matlab.ui.control.Label
    end

    
    properties (Access = private)

    end
    
    properties (Access = public)
        FullPathName            % the full path of the loaded image
        Vpiu                    %
        V                       %
        SimilarityImagesIndex   %
        MaximumImagesNumber = 5
        ContainerImmaginiSimili
        Uit                     % ui table   
        TabelCount = 1
    end
    


    methods (Access = private)
        
        
        %function results = func(app)
            
        %end
    end
    
    methods (Access = public)

        function mainFunctionSelfAtt(app, Vpiu, V)
            
            imageSize = StoreData.GetImageSize();
            directory = 'Images/foto_icon/';
            imagefiles = getImages(directory);     
            totImage = length(imagefiles);
                    
            simBest = zeros(totImage, 1);

            for index=1:totImage

                currentfilename = imagefiles(index).name;
                imdata = imread(strcat(directory, currentfilename));
                imdata = imresize(imdata, [imageSize imageSize]);
                imdata = im2gray(imdata);
                q = clm(imdata);
                
                nVpiu = size(Vpiu);
                nVpiu = nVpiu(1);
                selfAttVec = zeros(nVpiu,1);

                for ii=1:nVpiu
                    selfAttVec(ii) = selfAtt(Vpiu(ii, :), V(:, ii), q, 50);
                end

                selfAttNorm = normalization(selfAttVec(1), selfAttVec);
                simBest(index, 1) = abs(selfAttNorm);

            end

            app.SimilarityImagesIndex = sortVector(simBest, app.MaximumImagesNumber);              

            displayImages(app, imagefiles, Vpiu, V, directory);
            
            displayEvaluationTable(app, app.MaximumImagesNumber, totImage, simBest, app.SimilarityImagesIndex);

        end
        
        function    mainFunctionOrder(app, Vpiu, V)
            imageSize = StoreData.GetImageSize();
            directory = 'Images/foto_icon/';
            imagefiles = getImages(directory);     
            totImage = length(imagefiles);
            
            simBest = zeros(totImage, 1);
            
            for index=1:totImage
            
                currentfilename = imagefiles(index).name;
                imdata = imread(strcat(directory, currentfilename));
                imdata = imresize(imdata, [imageSize imageSize]);
                imdata = im2gray(imdata);
                q = clm(imdata);
                
                nVpiu = size(Vpiu);
                nVpiu = nVpiu(1);
                orderedVectors = zeros(nVpiu, imageSize.^2);
                
                for ii=1:nVpiu
                    X = Vpiu(ii, :); %matrix to row vector
                    orderedVectors(ii, :) = orderVector(X, q, 50);   %delta 5 sembra al limite per attendibilità
                end
                
                similarityVec = zeros(nVpiu,1);           
                
                for ii=1:nVpiu                  
                    similarityVec(ii) = sumVector(orderedVectors(ii, :));
                end
                
                simNorm = normalization(similarityVec(1), similarityVec); %1 corrisponde alla 1 foto per la ricerca, in questo caso il cerchio.
                simBest(index, 1) = abs(simNorm);
            end

            app.SimilarityImagesIndex = sortVector(simBest, app.MaximumImagesNumber);              

            displayImages(app, imagefiles, Vpiu, V, directory);
            
            displayEvaluationTable(app, app.MaximumImagesNumber, totImage, simBest, app.SimilarityImagesIndex);
                
        end

        function clearImageSimilarPanel(app)
            
            nContainer = length(app.ContainerImmaginiSimili);

            for ii=1:nContainer                
                delete(app.ContainerImmaginiSimili(ii));
            end

        end

        function displayImages(app, imagefiles, Vpiu, V, directory)
            imageSize = StoreData.GetImageSize();
            app.ImmaginiSimiliPanel.AutoResizeChildren = 'off';
            app.ContainerImmaginiSimili = [];
                        
            for ii=1:app.MaximumImagesNumber
                app.ContainerImmaginiSimili(ii) = subplot(3,5,ii,'Parent', app.ImmaginiSimiliPanel);
            end


            for jj=1:app.MaximumImagesNumber
                
                currentfilename = imagefiles(app.SimilarityImagesIndex(jj)).name;

                imdata = imread(strcat(directory, currentfilename));
                im = image(imdata,'Parent',app.ContainerImmaginiSimili(jj));
                if(jj == 1 && app.SelfAttVecButton.Value)
                    lenghtV = length(V);
                    matrixApp = zeros(lenghtV, 2);
                    imdata = imresize(imdata, [imageSize imageSize]);
                    imdata = im2gray(imdata);
                    matrixApp(:,1) = V(:,1);
                    matrixApp(:,2) = pinv(clm(imdata));

                    im.ButtonDownFcn = @(src,event)ImageClicked(app, matrixApp, event);
                end
            end
            
        end

        function ImageClicked(app, src, ~)
                VNew = feedback(src(:,1), src(:,2));
                app.V(:,1) = VNew;
                app.Vpiu = pinv(app.V);
                clearImageSimilarPanel(app);
                %app.ImmaginiSimiliPanel = uipanel('Title', 'Immagini Simili');
                mainFunctionSelfAtt(app, app.Vpiu, app.V);
        end

        function displayEvaluationTable(app, n, N, simBest, sortedVector)
            Rn = normalizedRecall(n, N, simBest, sortedVector);
            Pn = normalizedPrecision(n, N, simBest, sortedVector);
            Ln = lastPlaceRanking(n, N, simBest, sortedVector);
            
            t = table(Rn,Pn,Ln);
            fig = uifigure;
            app.Uit = uitable(fig,'Data',t);
                        
        end

    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: btn_ricercaImmagini
        function btn_ricercaImmaginiButtonPushed(app, event)
                app.ImmaginecaricataPanel.AutoResizeChildren = 'off';
                imageSize = StoreData.GetImageSize();
                containerImage = [];
                delete(subplot(1,1,1,'Parent', app.ImmaginecaricataPanel));
                containerImage(1) = subplot(1,1,1,'Parent', app.ImmaginecaricataPanel);
                [query_fname, query_pathname] = uigetfile('*.jpg', 'Selezione l imamagine che vuoi ricercare');    
                app.FullPathName = strcat(query_pathname, query_fname);  
                [pathstr, name, ext] = fileparts(app.FullPathName); 
                queryImage = imread( fullfile(pathstr, strcat(name, ext)));
                queryImage = imresize(queryImage, [imageSize imageSize]);
                %queryImage = rgb2gray(queryImage);
                image(queryImage,'Parent',containerImage(1));

        end

        % Button pushed function: CercaButton
        function btn_ricercaImmaginiSimili(app, event)
                app.Vpiu = extractVpiuVector(app.FullPathName);
                app.V = pinv(app.Vpiu);
                clearImageSimilarPanel(app);                
                if (app.SimilarityImageButton.Value)                
                    mainFunctionOrder(app, app.Vpiu, app.V);
                else
                    mainFunctionSelfAtt(app, app.Vpiu, app.V);
                end

        end

        % Value changed function: popupmenu_NumOfReturnedImages
        function popupmenu_NumOfReturnedImages_Callback(app, event)
             value = app.popupmenu_NumOfReturnedImages.Value;
             app.MaximumImagesNumber = str2num(value);
            
        end

        % Callback function
        function QualearrayButtonGroupSelectionChanged(app, event)
            selectedButton = app.QualearrayButtonGroup.SelectedObject;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.2118 0.2118 0.2118];
            app.UIFigure.Position = [100 100 733 555];
            app.UIFigure.Name = 'MATLAB App';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.FontSize = 13;
            app.Label.FontWeight = 'bold';
            app.Label.FontAngle = 'italic';
            app.Label.FontColor = [1 1 1];
            app.Label.Position = [19 515 592 22];
            app.Label.Text = 'On relevance feedback and similarity measure for image retrieval with synergetic neural nets';

            % Create MarianiFilippoRoselliPaoloPetrosilliMarcoLabel
            app.MarianiFilippoRoselliPaoloPetrosilliMarcoLabel = uilabel(app.UIFigure);
            app.MarianiFilippoRoselliPaoloPetrosilliMarcoLabel.HorizontalAlignment = 'right';
            app.MarianiFilippoRoselliPaoloPetrosilliMarcoLabel.FontSize = 10;
            app.MarianiFilippoRoselliPaoloPetrosilliMarcoLabel.FontAngle = 'italic';
            app.MarianiFilippoRoselliPaoloPetrosilliMarcoLabel.FontColor = [1 1 1];
            app.MarianiFilippoRoselliPaoloPetrosilliMarcoLabel.Position = [643 508 74 37];
            app.MarianiFilippoRoselliPaoloPetrosilliMarcoLabel.Text = {'Mariani Filippo'; 'Roselli Paolo'; 'Petrosilli Marco'};

            % Create ImmaginiSimiliPanel
            app.ImmaginiSimiliPanel = uipanel(app.UIFigure);
            app.ImmaginiSimiliPanel.Title = 'Immagini Simili';
            app.ImmaginiSimiliPanel.BackgroundColor = [0.651 0.651 0.651];
            app.ImmaginiSimiliPanel.Position = [19 236 457 264];

            % Create btn_ricercaImmagini
            app.btn_ricercaImmagini = uibutton(app.UIFigure, 'push');
            app.btn_ricercaImmagini.ButtonPushedFcn = createCallbackFcn(app, @btn_ricercaImmaginiButtonPushed, true);
            app.btn_ricercaImmagini.Tag = 'btn_BrowseImage';
            app.btn_ricercaImmagini.BackgroundColor = [0.6 0.8902 0.2314];
            app.btn_ricercaImmagini.FontSize = 18;
            app.btn_ricercaImmagini.FontWeight = 'bold';
            app.btn_ricercaImmagini.Position = [502 128 213 45];
            app.btn_ricercaImmagini.Text = 'Carica un immagine';

            % Create ImmaginiDatabasePanel
            app.ImmaginiDatabasePanel = uipanel(app.UIFigure);
            app.ImmaginiDatabasePanel.Title = 'Immagini Database';
            app.ImmaginiDatabasePanel.BackgroundColor = [0.651 0.651 0.651];
            app.ImmaginiDatabasePanel.Position = [19 23 457 203];

            % Create Image
            app.Image = uiimage(app.ImmaginiDatabasePanel);
            app.Image.Position = [14 129 43 43];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.41.19.jpg');

            % Create Image_10
            app.Image_10 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_10.Position = [14 72 43 43];
            app.Image_10.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.45.39.jpg');

            % Create Image_11
            app.Image_11 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_11.Position = [14 15 43 43];
            app.Image_11.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.48.58.jpg');

            % Create Image_13
            app.Image_13 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_13.Position = [69 129 43 43];
            app.Image_13.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.41.36.jpg');

            % Create Image_14
            app.Image_14 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_14.Position = [69 72 43 43];
            app.Image_14.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.46.25.jpg');

            % Create Image_15
            app.Image_15 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_15.Position = [69 15 43 43];
            app.Image_15.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.49.04.jpg');

            % Create Image_17
            app.Image_17 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_17.Position = [125 129 43 43];
            app.Image_17.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.44.00.jpg');

            % Create Image_18
            app.Image_18 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_18.Position = [125 72 43 43];
            app.Image_18.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.47.23.jpg');

            % Create Image_19
            app.Image_19 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_19.Position = [125 15 43 43];
            app.Image_19.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.49.15.jpg');

            % Create Image_21
            app.Image_21 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_21.Position = [180 129 43 43];
            app.Image_21.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.44.14.jpg');

            % Create Image_22
            app.Image_22 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_22.Position = [180 72 43 43];
            app.Image_22.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.47.35.jpg');

            % Create Image_23
            app.Image_23 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_23.Position = [180 15 43 43];
            app.Image_23.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.49.50.jpg');

            % Create Image_25
            app.Image_25 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_25.Position = [236 129 43 43];
            app.Image_25.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.44.29.jpg');

            % Create Image_26
            app.Image_26 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_26.Position = [236 72 43 43];
            app.Image_26.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.47.44.jpg');

            % Create Image_27
            app.Image_27 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_27.Position = [236 15 43 43];
            app.Image_27.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.50.18.jpg');

            % Create Image_29
            app.Image_29 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_29.Position = [291 129 43 43];
            app.Image_29.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.44.47.jpg');

            % Create Image_30
            app.Image_30 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_30.Position = [291 72 43 43];
            app.Image_30.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.47.54.jpg');

            % Create Image_31
            app.Image_31 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_31.Position = [291 15 43 43];
            app.Image_31.ImageSource = fullfile(pathToMLAPP, 'Images', 'circle.jpg');

            % Create Image_33
            app.Image_33 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_33.Position = [347 129 43 43];
            app.Image_33.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.45.09.jpg');

            % Create Image_34
            app.Image_34 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_34.Position = [347 72 43 43];
            app.Image_34.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.48.31.jpg');

            % Create Image_35
            app.Image_35 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_35.Position = [347 15 43 43];
            app.Image_35.ImageSource = fullfile(pathToMLAPP, 'Images', 'keywords', 'square.jpg');

            % Create Image_37
            app.Image_37 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_37.Position = [402 129 43 43];
            app.Image_37.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.45.19.jpg');

            % Create Image_38
            app.Image_38 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_38.Position = [402 72 43 43];
            app.Image_38.ImageSource = fullfile(pathToMLAPP, 'Images', 'foto_icon', 'Screenshot 2022-12-16 alle 16.48.44.jpg');

            % Create Image_39
            app.Image_39 = uiimage(app.ImmaginiDatabasePanel);
            app.Image_39.Position = [402 15 43 43];
            app.Image_39.ImageSource = fullfile(pathToMLAPP, 'Images', 'keywords', 'triangle.jpg');

            % Create ImmaginecaricataPanel
            app.ImmaginecaricataPanel = uipanel(app.UIFigure);
            app.ImmaginecaricataPanel.Title = 'Immagine caricata';
            app.ImmaginecaricataPanel.BackgroundColor = [0.651 0.651 0.651];
            app.ImmaginecaricataPanel.Position = [502 280 212 219];

            % Create CercaButton
            app.CercaButton = uibutton(app.UIFigure, 'push');
            app.CercaButton.ButtonPushedFcn = createCallbackFcn(app, @btn_ricercaImmaginiSimili, true);
            app.CercaButton.BackgroundColor = [0.6 0.8902 0.2314];
            app.CercaButton.FontSize = 18;
            app.CercaButton.FontWeight = 'bold';
            app.CercaButton.Position = [502 183 212 43];
            app.CercaButton.Text = 'Cerca';

            % Create popupmenu_NumOfReturnedImages
            app.popupmenu_NumOfReturnedImages = uidropdown(app.UIFigure);
            app.popupmenu_NumOfReturnedImages.Items = {'5', '10', '15'};
            app.popupmenu_NumOfReturnedImages.ValueChangedFcn = createCallbackFcn(app, @popupmenu_NumOfReturnedImages_Callback, true);
            app.popupmenu_NumOfReturnedImages.Tag = 'popupmenu_NumOfReturnedImages';
            app.popupmenu_NumOfReturnedImages.FontSize = 15;
            app.popupmenu_NumOfReturnedImages.FontWeight = 'bold';
            app.popupmenu_NumOfReturnedImages.BackgroundColor = [1 1 1];
            app.popupmenu_NumOfReturnedImages.Position = [503 236 215 22];
            app.popupmenu_NumOfReturnedImages.Value = '5';

            % Create QualearrayButtonGroup
            app.QualearrayButtonGroup = uibuttongroup(app.UIFigure);
            app.QualearrayButtonGroup.Title = 'Quale array?';
            app.QualearrayButtonGroup.BackgroundColor = [0.651 0.651 0.651];
            app.QualearrayButtonGroup.Position = [503 23 213 93];

            % Create SimilarityImageButton
            app.SimilarityImageButton = uiradiobutton(app.QualearrayButtonGroup);
            app.SimilarityImageButton.Tag = 'SimilarityImageButton';
            app.SimilarityImageButton.Text = 'Similarity Image';
            app.SimilarityImageButton.FontSize = 17;
            app.SimilarityImageButton.Position = [11 34 143 22];
            app.SimilarityImageButton.Value = true;

            % Create SelfAttVecButton
            app.SelfAttVecButton = uiradiobutton(app.QualearrayButtonGroup);
            app.SelfAttVecButton.Tag = 'SelfAttVecButton';
            app.SelfAttVecButton.Text = 'Self Att Vec';
            app.SelfAttVecButton.FontSize = 17;
            app.SelfAttVecButton.Position = [11 8 110 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = designImageRetrieval

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end