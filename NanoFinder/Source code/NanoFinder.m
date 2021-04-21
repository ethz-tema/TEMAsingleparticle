    % Author: Kamyar Mehrabi Kochehbyoki/ https://gitHub.com/kammk 
    % GitHub repository of the program: https://github.com/ethz-tema/TEMAsingleparticle
    % Email: kamyarm@ethz.ch
    % Release date 2021.03.01
    % Version NanoFinder V4.2
    % Open access licence by ETH Zürich

classdef NanoFinder < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        SummarySwitchLabel              matlab.ui.control.Label
        SummarySwitch                   matlab.ui.control.Switch
        RunButton                       matlab.ui.control.Button
        Integration_windowEditFieldLabel  matlab.ui.control.Label
        Integration_windowEditField     matlab.ui.control.NumericEditField
        Least_countEditFieldLabel       matlab.ui.control.Label
        Least_countEditField            matlab.ui.control.NumericEditField
        NanoparticletonoiseEditFieldLabel  matlab.ui.control.Label
        NanoparticletonoiseEditField    matlab.ui.control.NumericEditField
        Smooth_windowEditFieldLabel     matlab.ui.control.Label
        Smooth_windowEditField          matlab.ui.control.NumericEditField
        StartdatapointrownumberEditFieldLabel  matlab.ui.control.Label
        StartdatapointrownumberEditField  matlab.ui.control.NumericEditField
        InputdataformatDropDownLabel    matlab.ui.control.Label
        InputdataformatDropDown         matlab.ui.control.DropDown
        EnddatapointrownumberEditFieldLabel  matlab.ui.control.Label
        EnddatapointrownumberEditField  matlab.ui.control.NumericEditField
        NumberofreplicatesEditFieldLabel  matlab.ui.control.Label
        NumberofreplicatesEditField     matlab.ui.control.NumericEditField
        ReadsettingfromfileSwitchLabel  matlab.ui.control.Label
        ReadsettingfromfileSwitch       matlab.ui.control.Switch
        Image                           matlab.ui.control.Image
        DLampLabel                      matlab.ui.control.Label
        DLamp                           matlab.ui.control.Lamp
        SLampLabel                      matlab.ui.control.Label
        SLamp                           matlab.ui.control.Lamp
        CLampLabel                      matlab.ui.control.Label
        CLamp                           matlab.ui.control.Lamp
        DetectionSwitchLabel            matlab.ui.control.Label
        DetectionSwitch                 matlab.ui.control.Switch
        ConcurrencySwitchLabel          matlab.ui.control.Label
        ConcurrencySwitch               matlab.ui.control.Switch
        Lamp                            matlab.ui.control.Lamp
        ClusteringSwitchLabel           matlab.ui.control.Label
        ClusteringSwitch                matlab.ui.control.Switch
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Callback function
        function AmplitudeSliderValueChanged(app, event)
            value = app.AmplitudeSlider.Value;
            plot(app.UIAxes, value*peaks)
            app.UIAxes.YLim =[-1000 1000];
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            %app.AmplitudeSlider.Value=app.Initial_valueEditField.Value;
            %value = app.AmplitudeSlider.Value;
            %plot(app.UIAxes, value*peaks)
            %app.UIAxes.YLim =[-1000 1000];
            app.Lamp.Color = [1 0 0] ;
            
            tic
            [filed,path] = uigetfile('../*.xlsx');
            cd (path)
            
            [tc]=read_file(filed);
            tc=tc(2:end,:);
            [nsh,tx] = xlsread(filed,'Elements');
            
            sumy='No';
            if strcmp(app.SummarySwitch.Value, 'Yes')
                sumy='Yes';
            end
            
            Detect='No';
            if strcmp(app.DetectionSwitch.Value, 'Yes')
                Detect='Yes';
            end
            
            conc='No';
            if strcmp(app.ConcurrencySwitch.Value, 'Yes')
                conc='Yes';
            end
            
            if strcmpi(Detect,'yes')
                app.DLamp.Color = [1 0 0] ;
                if strcmp(app.ReadsettingfromfileSwitch.Value, 'No')
                    
                    
                    typ='h5';
                    if strcmp(app.InputdataformatDropDown.Value, 'CSV')
                        typ='CSV';
                    end
                    WF=app.Integration_windowEditField.Value;
                    limit=app.Least_countEditField.Value;
                    Goldnum=app.NanoparticletonoiseEditField.Value;
                    smooth_window=app.Smooth_windowEditField.Value;
                    st=app.StartdatapointrownumberEditField.Value;
                    ed=app.EnddatapointrownumberEditField.Value;
                    replicatN=app.NumberofreplicatesEditField.Value;
                    if replicatN==0
                        replicatN=1;
                    end
                else
                    %size is specifyed 74111
                    %Waveform is speciyed 44
                    %size of the internal data is specifyed 250*400
                    %can switch between Tofware, h5 and CSV change variable 'typ'
                    % same number of replicate and file size only suported
                    
                    [nm,tm]=xlsread(filed,'Read me AIO');
                    WF=nm(1,1);
                    limit=nm(2,1);
                    Goldnum=nm(3,1);
                    smooth_window=nm(4,1);
                    st=nm(5,1);
                    ed=nm(6,1);
                    if length(nm)==7
                        replicatN=nm(7,1);
                    else
                        replicatN=1;
                    end
                    typ=tm{8,2};
                end
                %size is specifyed 74111
                %Waveform is speciyed 44
                %size of the internal data is specifyed 250*400
                %can switch between Tofware, h5 and CSV change variable 'typ'
                % same number of replicate and file size only suported
                
                %clear
                %[filed,path] = uigetfile('../*.xlsx');
                %cd (path)
                
                %[nm,tm]=xlsread(filed,'Read me AIO');
                %WF=nm(1,1);
                %limit=nm(2,1);
                %Goldnum=nm(3,1);
                %smooth_window=nm(4,1);
                %st=nm(5,1);
                % ed=nm(6,1);
                %if length(nm)==7
                %    replicatN=nm(7,1);
                %else
                %    replicatN=1;
                %end
                %typ=tm{8,2};
                %sumy=tm{9,2};
                
                
                %WF=44 % number of waveform
                %limit=3.5 %loest Sc accepted
                %Goldnum=40 % Number which define the levlel of NP existance in the file "thriky one" the number of detected nanoparticle devided by number of estimated false positive
                %smooth_window=50;
                %typ='h5'%need to be change according to your data format 'csv' or 'h5'
                %replicatN=3%
                
                %[tc]=read_file(filed);
                %tc=tc(2:end,:);
                
                tcl=size(tc);
                
                if tcl(1)==0
                    [itc]=read_replicate(typ,replicatN,filed); % if there are many H5 files that couldnt be enter manually
                    tcl=size(itc);
                    otc=itc(:,1);
                    xlswrite(filed,otc,'Filename','A2');
                    
                    d=zeros(tcl(1),1);
                    for i=1:tcl(1)
                        for j=1:tcl(2)
                            if ~isempty (itc{i,j})
                                d(i)=d(i)+1;
                            end
                        end
                    end
                    
                elseif isempty (tc{1,2})
                    otc=tc(:,1);
                    [itc]=read_replicate(typ,replicatN,filed); % if there are many H5 files that couldnt be enter manually
                    tcl=size(itc);
                    %tc=itc;
                    
                    d=zeros(tcl(1),1);
                    for i=1:tcl(1)
                        for j=1:tcl(2)
                            if ~isempty (itc{i,j})
                                d(i)=d(i)+1;
                            end
                        end
                    end
                    
                elseif isempty (tc{1,1})
                    itc=tc(:,2:end);
                    tcl=size(itc);
                    otc=itc(:,1);
                    xlswrite(filed,otc,'Filename','A2');
                    
                    d=zeros(tcl(1),1);
                    for i=1:tcl(1)
                        for j=1:tcl(2)
                            if ~isempty (itc{i,j})
                                d(i)=d(i)+1;
                            end
                        end
                    end
                    
                else
                    itc=tc(:,2:end);
                    tcl=size(itc);
                    otc=tc(:,1);
                    
                    d=zeros(tcl(1),1);
                    for i=1:tcl(1)
                        for j=1:tcl(2)
                            if ~isempty (itc{i,j})
                                d(i)=d(i)+1;
                            end
                        end
                    end
                    
                end
                
                
                tc_new=itc;
                tc=otc;
                
                tcsize=size(tc_new)
                Y=zeros([1,tcsize(1)])
                f1=figure
                X = categorical(tc(:,1));
                X = reordercats(X,tc(:,1));
                f1=barh(X,Y) % Error here is due to the name replicate number
                title('reading data (%)')
                saveas(f1,'reading data AIO.pdf')
                
                
                
                
                %Bumper setting
                sumfac=30 % number of data point in the bump
                alfac=11 % max of NP in each bump area
                alfad=0.01;% top finder
                %Count_limit=1000000;
                
                
                %xlswrite(filed,[{'WF'},{'limit'},{'Goldnum'},{'smooth_window'},{'replicatN'},{'alfad'},{'sumfac'},{'alfac'},{'Count_limit'},{'date'}]','Read me AIO','A2');
                %xlswrite(filed,[WF,limit,Goldnum,smooth_window,replicatN,alfad,sumfac,alfac,Count_limit,{date}]','Read me AIO','B2');
                xlswrite(filed,[{'Integration window'},{'Least count'},{'Nanoparticle to noise'},{'Smooth_window'},{'Start data point row number'},{'End data point row number'},{'Number of replicates to sum up'}, ...
                    {'Data file format (h5 or csv)'},{'Summary of analysis'},{'Particles concurrency analysis'},{'Date of processing'}]','Read me AIO','A1');
                xlswrite(filed,[WF,limit,Goldnum,smooth_window,st,ed,replicatN,typ,sumy,conc,{date}]','Read me AIO','B1');
                
                
                %[nd ,tc ] = xlsread(filed,'sheet1');
                
                %[nsh,tx] = xlsread(filed,'Elements');
                [nl,txl] = xlsread(filed,'Line');
                tsh=el_sim_two(tx);
                tsh=tsh';
                %slop=nd(:,1); % for calculatng the Lc and Sc
                %incp=nd(:,2);
                %slops=nd(:,1);
                %incps=nd(:,2);
                Total_sample=[];
                Total_drp1=[];
                Total_diss=[];
                Completed_newlamda=[];
                sum_datad=[];
                nnpv=[];
                                
                for ia=1:tcsize(1)
                    
                    Y(ia)=10
                    f1=barh(X,Y)
                    title('reading data (%)')
                    drawnow
                    saveas(f1,'reading data AIO.pdf')
                    
                    
                    %d=tcsize(2);
                    Completed_data=[];
                    Completed_drp1=[];
                    Completed_diss=[];
                    newlamda=[];
                    for f=1:d(ia) %for the number of columns in filename this loop will be repeated%
                        strn=tc_new{ia,f}
                        [sample,diss,strn]= Readtof(typ,strn,tx,WF,st,ed);
                        %[txt,sample,dropb1,dropb2,diss,strn]= Readtofcsv(strn);
                        %Completed_data=sample;
                        
                        
                        
                        
                        % smoth the data
                        dfg=sample;
                        samp=smoothdata(sample,'movmedian',smooth_window);
                        avy=mean(samp);
                        %newlamda=cat(2,newlamda,avy');
                        sample=sample-samp+avy;
                        % dropee=smoothdata(dropb1,'movmedian',smooth_window);
                        %  avyd=mean(dropee);
                        %  dropb1=dropb1-dropee+avyd;
                        
                        
                        Completed_data=cat(1,Completed_data,sample);
                        %  Completed_drp1=cat(1,Completed_drp1,dropb1);
                        Completed_diss=cat(1,Completed_diss,diss);
                        newlamda=cat(1,newlamda,avy);
                    end
                    %[Completed_databumpernotused,Alfat,bump_num,Datad]=Bumper(Completed_data,alfad,sumfac,alfac);
                    
                    %sum_datad=cat(1,sum_datad,bump_num);
                    Total_sample=cat(3,Total_sample,Completed_data);
                    Total_drp1=cat(3,Total_drp1,Completed_drp1);
                    Total_diss=cat(2,Total_diss,Completed_diss');
                    Completed_newlamda=cat(2,Completed_newlamda,newlamda');
                    
                    Y(ia)=100
                    f1=barh(X,Y)
                    title('reading data (%)')
                    drawnow
                    saveas(f1,'reading data AIO.pdf')
                    
                end
                
                Y=zeros([1,2])
                f2=figure
                X = categorical({'Thresholding','Detection'});
                X = reordercats(X,{'Thresholding','Detection'});
                f2=barh(X,Y)
                title('Processing data (%)')
                saveas(f2,'Processing data AIO.pdf')
                
                lsize=size(nl);
                Thpos=[];
                Thpos_value=[];
                Thpos_lamda=[];
                Thspos_value=[];
                for ig=1:lsize(1)
                    
                    Y(1)=Y(1)+(100/lsize(1)/2)
                    f2=barh(X,Y)
                    title('Processing data (%)')
                    drawnow
                    saveas(f2,'Processing data AIO.pdf')
                    
                    slope=nl(ig,2);
                    incp=nl(ig,3);
                    slopes=nl(ig,5);
                    incps=nl(ig,6);
                    sumnpp=[];
                    size_data=size(Total_sample);
                    sd=sort(Total_sample,1,'descend');
                    sd=sd(round(size_data(1)*nl(ig,1)*Goldnum):end,:,:); %%% change on 2020.07.07
                    lamda = squeeze(mean(sd,1));
                    lamda=reshape(lamda,[],tcsize(1));
                    lamda(lamda<0)=0;
                    %lamda=Completed_newlamda;
                    Sc=lamda+(slope*sqrt(lamda))+incp;%be carful Sc is included lamda so it not Lc
                    Sc(Sc<limit)=limit;
                    Sc=reshape(Sc,[],tcsize(1));
                    Scs=lamda+(slopes'.*sqrt(lamda))+incps';
                    Scs(Scs<limit)=limit;
                    Scs=reshape(Scs,[],tcsize(1));
                    for ja=1:tcsize(1)
                        
                        name_function='elementwise';
                        str = strcat(tc(ja,1),{'.xlsx'});
                        file=[str{:}];
                        
                        %file=tc{i,1}
                        [~,data_split_one]=split_correct(name_function,Total_sample(:,:,ja),file,tsh,lamda(:,ja)',Scs(:,ja)');
                        
                        [sumNp,avgNp,TrueDiss,npp,npv,Binary_detection]=Top_finder(Sc(:,ja)',data_split_one);
                        x=sum(npp,1);
                        sumnpp=cat(1,sumnpp,x);
                    end
                    sumnpp=sumnpp/(2*size_data(1)*nl(ig,1)); % the number of detected nanoparticle devided by number of false positive
                    Thpos=cat(3,Thpos,sumnpp);
                    Thpos_value=cat(3,Thpos_value,Sc');
                    Thspos_value=cat(3,Thspos_value,Scs');
                    Thpos_lamda=cat(3,Thpos_lamda,lamda');
                    
                    Y(1)=Y(1)+(100/lsize(1)/2)
                    f2=barh(X,Y)
                    title('Processing data (%)')
                    drawnow
                    saveas(f2,'Processing data AIO.pdf')
                    
                end
                Thpos_size=size(Thpos);
                Th_final_value=nan(Thpos_size(1),Thpos_size(2));
                Ths_final_value=nan(Thpos_size(1),Thpos_size(2));
                Th_final_lamda=nan(Thpos_size(1),Thpos_size(2));
                Th_final=nan(Thpos_size(1),Thpos_size(2));
                for id=1:Thpos_size(1)
                    for jd=1:Thpos_size(2)
                        for kd=1:Thpos_size(3)
                            if Thpos(id,jd,kd)>Goldnum % important decision on
                                Th_final(id,jd)=kd;
                                Th_final_value(id,jd)=Thpos_value(id,jd,kd);
                                Ths_final_value(id,jd)=Thspos_value(id,jd,kd);
                                Th_final_lamda(id,jd)=Thpos_lamda(id,jd,kd); %erro in this line is due to the fact you only have one row of file name in your Filename please increase it to altesat2
                                break
                            else
                                if kd==Thpos_size(3)
                                    Th_final(id,jd)=-kd;% need to be modiey "what if therre were no particles!!?"
                                    Th_final_value(id,jd)=Thpos_value(id,jd,kd);
                                    Ths_final_value(id,jd)=Thspos_value(id,jd,kd);
                                    Th_final_lamda(id,jd)=Thpos_lamda(id,jd,kd);
                                    
                                end
                            end
                            
                        end
                    end
                end
                %xlswrite(filed,Th_final_lamda,'Th_final_lamda','A1');
                %xlswrite(filed,Th_final_value,'Th_final_value','A1');
                %xlswrite(filed,Ths_final_value,'Ths_final_value','A1');
                %xlswrite(filed,Th_final,'Th_final','A1');
                
                
                
                %[Th_final_lamda,Ths_final_value,Th_final_value,Th_final]=Count_to_Gaussian(Total_sample,Th_final_lamda,Ths_final_value,Th_final_value,Count_limit,Th_final);
                Allnpv=[];
                for ib=1:tcsize(1)
                    
                    name_function='elementwise'
                    str = strcat(tc(ib,1),{'.xlsx'});
                    file=[str{:}]
                    
                    %file=tc{i,1}
                    [Binary_split,data_split]=split_correct(name_function,Total_sample(:,:,ib),file,tsh,Th_final_lamda(ib,:),Ths_final_value(ib,:));
                    
                    [sumNp,avgNp,TrueDiss,npp,npv,Binary_detection]=Top_finder(Th_final_value(ib,:),data_split);
                    npv=npv-TrueDiss;
                    npv(npv<0)=0;
                    avgNp=avgNp-TrueDiss;
                    split_event=Binary_split;
                    split_event(split_event>0)=0;
                    split_event=split_event.*npp;
                    split_event=split_event.*-1;
                    split_event_count=sum(split_event);
                    A=npv;
                    A(A==0) = NaN;
                    medNP = nanmedian(A);
                    
                    SizeB=size(Binary_detection);
                    sumNpFP=round(2*SizeB(1)*nl(abs(Th_final(ib,:))),0);
                    
                    [Cor_matrix,Cor_p_value]=correlation_coefs (Binary_detection,npv,file,tsh);
                    xlswrite(file,[{'Avg raw signal_counts'};{'Lamda_counts'};{'TrueDiss_counts'};{'Avg NP_counts'};{'Med NP_counts'};{'Total NP'};{'FALSE POSITIVE Estimation'};{'Lc_Critical value_counts'};{'Sc_Threshold_counts'};{'Scs_Threshold split_counts'};{'FALSE POSITIVE level'};{'split_events'}],'Avg','A2');
                    xlswrite(file,tsh,'Avg','B1');
                    xlswrite(file,[Total_diss(:,ib)';Th_final_lamda(ib,:);TrueDiss;avgNp;medNP;sumNp;sumNpFP;(Th_final_value(ib,:)-TrueDiss);Th_final_value(ib,:);Ths_final_value(ib,:);Th_final(ib,:);split_event_count],'Avg','B2');
                    
                    %xlswrite(file,tsh,'npv','A1');
                    %xlswrite(file,npv,'npv','A2');
                    %nnpv=cat(3,nnpv,npv);
                    
                    str = strcat(tc(ib,1),{'.npv.csv'});
                    file=[str{:}]
                    tit=el_sim_two(tsh);
                    Allnpv=cat(3,Allnpv,npv);
                    sd = array2table(npv);
                    sd.Properties.VariableNames=tit;
                    writetable(sd,file,'Delimiter',',')
                    
                    
                    Y(2)=Y(2)+(100/tcsize(1))
                    f2=barh(X,Y)
                    title('Processing data (%)')
                    drawnow
                    saveas(f2,'Processing data AIO.pdf')
                end
                app.DLamp.Color = [0 1 0] ;
            end
            
            if strcmpi(sumy,'yes')
                app.SLamp.Color = [1 0 0] ;
                Y=0
                f3=figure
                X = categorical({'Summary'});
                X = reordercats(X,{'Summary'});
                f3=barh(X,Y)
                title('Summary progress (%)')
                saveas(f3,'Summary AIO.pdf')
                
                %Reading
                
                tcsize=size(tc)
                npn=[];
                con=[];
                sumdata=[];
                
                for i=1:tcsize(1)
                    str = strcat(tc(i,1),{'.xlsx'});
                    file=[str{:}]
                    [nn,tn] = xlsread(file,'NP Number');
                    npn=cat(3,npn,nn);
                    %[ncon,tcon] = xlsread(file,'Concurrent');
                    %con=cat(3,con,ncon);
                    [nsum,tsum] = xlsread(file,'Avg');
                    sumdata=cat(3,sumdata,nsum);
                    
                    Y=Y+(10/tcsize(1));
                    f3=barh(X,Y)
                    title('Summary progress (%)')
                    drawnow
                    saveas(f3,'Summary AIO.pdf')
                end
                %Calculating Concurrency
                sznpn=size(npn);
                pers=[];
                ratio=[];
                %for i=1:sznpn(1)
                %    x= (npn(:,i,:)-con(:,i,:))./npn(i,i,:)*100;
                %     x = squeeze(x);
                %    pers=cat(3,pers,x);
                
                %    z=con;
                %     z(z==0)=0.4;
                %     y= (npn(:,i,:)-sqrt(npn(:,i,:)))./z(:,i,:);
                %   y = squeeze(y);
                %    y(i,:)=nan;
                %     ratio=cat(3,ratio,y);
                % end
                
                
                %writing Concurrency
                for ik=1:sznpn(1)
                    match = ["+"];
                    nsheet=tn(ik+1,1);
                    nsheet= erase(nsheet,match);
                    
                    [A1,A2,B1,B2]=exgen(sznpn(2),ik);
                    
                    xlswrite(filed,tc','NP number overall',B1);
                    xlswrite(filed,tn(:,1),'NP number overall',A1);
                    xlswrite(filed,nsheet,'NP number overall',A1);
                    xr = squeeze(npn(:,ik,:));
                    xlswrite(filed,round(xr,1),'NP number overall',B2);
                    
                    
                    
                    %[A1,A2,B1,B2]=exgen(sznpn(2),1);
                    
                    %xlswrite(filed,tc',[nsheet{:}],B1);
                    %xlswrite(filed,tn(:,1),[nsheet{:}],A1);
                    %xlswrite(filed,{'Actual number'},[nsheet{:}],A1);
                    %xr = squeeze(npn(:,i,:));
                    %xlswrite(filed,round(xr,1),[nsheet{:}],B2);
                    
                    %[A1,A2,B1,B2]=exgen(sznpn(2),2);
                    
                    %xlswrite(filed,tc',[nsheet{:}],B1);
                    %xlswrite(filed,tn(:,1),[nsheet{:}],A1);
                    %xlswrite(filed,{'Ratio'},[nsheet{:}],A1);
                    %xlswrite(filed,round(ratio(:,:,i),1),[nsheet{:}],B2);
                    
                    
                    %[A1,A2,B1,B2]=exgen(sznpn(2),3);
                    
                    %xlswrite(filed,tc',[nsheet{:}], B1);
                    %xlswrite(filed,tn(:,1),[nsheet{:}],A1);
                    %xlswrite(filed,{'Concurency'},[nsheet{:}],A1);
                    %xr = squeeze(con(:,i,:));
                    %xlswrite(filed,round(xr,1),[nsheet{:}],B2);
                    
                    %[A1,A2,B1,B2]=exgen(sznpn(2),4);
                    
                    %xlswrite(filed,tc',[nsheet{:  }],B1);
                    %xlswrite(filed,tn(:,1),[nsheet{:}],A1);
                    %xlswrite(filed,{'Percentage'},[nsheet{:}],A1);
                    %xlswrite(filed,round(pers(:,:,i),1),[nsheet{:}],B2);
                    
                    Y=Y+(70/sznpn(1));
                    f3=barh(X,Y)
                    title('Summary progress (%)')
                    drawnow
                    saveas(f3,'Summary AIO.pdf')
                    
                    
                end
                
                
                
                %Writing the metadeta
                
                % hol=zeros(sznpn(1),tcsize(1));
                % for i=1:tcsize(1)
                %     for j=1:sznpn(1)
                %         hol(j,i)=npn(j,j,i);
                %     end
                % end
                % xlswrite(filed,tc','Total NP','B1');
                % xlswrite(filed,tn(:,1),'Total NP','A1');
                % xlswrite(filed,{'Total NP'},'Total NP','A1');
                % xlswrite(filed,hol,'Total NP','B2');
                
                tsumsize=size(tsum);
                
                for i=2:tsumsize(1)
                    xlswrite(filed,tc',tsum{i,1},'B1');
                    xlswrite(filed,tn(:,1),tsum{i,1},'A1');
                    xr = squeeze(sumdata(i-1,:,:));
                    %if tcsize(1)==1
                    %    xr=xr';
                    %end
                    xlswrite(filed,xr,tsum{i,1},'B2');
                    
                    Y=Y+(20/tsumsize(1));
                    f3=barh(X,Y)
                    title('Summary progress (%)')
                    drawnow
                    saveas(f3,'Summary AIO.pdf')
                end
                
                Y=100;
                f3=barh(X,Y)
                title('Summary progress (%)')
                drawnow
                saveas(f3,'Summary AIO.pdf')
                app.SLamp.Color = [0 1 0] ;
            end
            
            if strcmpi(conc,'yes')
                app.CLamp.Color = [1 0 0] ;
                %udt=10; % user define min events per element for concurrency
                %mec=34; % max element in the councrency
                %[nm,tm] = xlsread(filed,'Read me Coun');
                tx=tx';
                tax=el_sim(tx(:,1));
                %tcsize=size(tc)
                NPdata=[];
                
                tcsize=size(tc)
                Y=zeros([1,tcsize(1)])
                f1=figure
                X = categorical(tc(:,1));
                X = reordercats(X,tc(:,1));
                f1=barh(X,Y)
                title('Coun Processing time (s)')
                saveas(f1,'Coun Processing time.pdf')
                
                fac=1;
                fac2=2%nm(1,1);
                exn='.npv.csv';%.npv.csv
                
                %cutof=0.8;  %something for hierarcial classifcation
                %fac=1;     % dont consider event happened less than this number in fist run
                %fac2=2;    % further decreasing the number of minimom event to be deal with
                fac3=[];    %normally 1 or 2. fot cuncurency decition how many time an mix event should be larger than its concurent to not be consider as fake
                valu=0.49; %for grouping decition 0.49 for low sub group o.5 for higher subgroup
                base=3;    % base for coding of the data minimom of 3. the base 2 wont work properly
                chans=0;  % if a NPc compose of NP (A and B) what should be thier subtraction to place chans insted of that small number %please look at the code for more informaiton
                
                %xlswrite(filed,[{'Min Freq Coun'},{'File name additon text'},{'Date'}]','Read me Coun','A2');
                %xlswrite(filed,[fac2,exn,{date}]','Read me Coun','B2');
                
                %tope_core=cellstr(dec2base(ntope,3));   %use version V6.3 to get file separate data
                %tope=tope_core'; % position of this line in chase you want to have a constant and prograssive "tope" for all
                
                class_store=[]
                for ti=1:tcsize(1)
                    start_con=toc;
                    
                    Y(ti)=toc-start_con;
                    f1=barh(X,Y)
                    title('Coun Processing time (s)')
                    drawnow
                    saveas(f1,'Coun Processing time.pdf')
                    
                    
                    
                    
                    
                    tope=[];%tope_core'; % position of this line in chase you want to change "tope" per sample
                    nnpv=[];
                    for fw=1:1 %for the number of rows in filename this loop will be repeated%
                        str = strcat(tc(ti,fw),{exn}); %%%%%%%%%%%%%%%%%%%%%%
                        file=[str{:}]%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [pv,tnpv] = xlsread(file);
                        %[txt,sample,dropb1,dropb2,diss,strn]= Readtofcsv(strn);
                        %Completed_data=sample;
                        nnpv=cat(1,nnpv,pv);
                    end
                    
                    %nev=Allnpv(:,:,ti);
                    %[nnpv,tax,elem_list]=select_Concurency(nev,tx,udt,mec); %Addition to original
                    
                    
                    Y(ti)=toc-start_con;
                    f1 =barh(X,Y);
                    title('Coun Processing time (s)')
                    saveas(f1,'Coun Processing time.pdf')
                    
                    %str = strcat(tc(ti),{'.xlsx'}); %%%%%%%%%%%%%%%%%%%%%%
                    %file=[str{:}]%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %[nnpv,tnpv] = xlsread(file,'npv');%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    NPdata=nnpv;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    NPdata_con=nnpv;
                    %nnpv(nnpv<0)=0;% it is neccessry since it wont work with negative vlues
                    %NPdata=nnpv;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    str = strcat(tc(ti,1),{'.xlsx'});
                    file = [str{:}];
                    
                    % part 1 counting
                    [List_1, layer_data, unic_freq_data,nns]=unic_num(NPdata,fac,base); %make sure the line data are correct
                    %[List_1_E,last_write_pos_E]=Squeez_Write(tc,ti,List_1,1,file,base,tax);
                    [List_1_E,last_write_pos_E]=Squeez_Write(tc,ti,List_1,1,file,base,tax,'Before Coun');
                    Y(ti)=toc-start_con;
                    f1=barh(X,Y);
                    title('Coun Processing time (s)')
                    saveas(f1,'Coun Processing time.pdf')
                    
                    %part 2  considering concurency
                    List_2=List_1;
                    
                    %%%%%%%%%%%%% one can delete part 2 from here to not apply concurency effect on the data and deal with raw data for classification
                    sizedata=size(NPdata);
                    sizelist=size(List_2);
                    for o=sizelist(2):-1:2
                        x=List_2{o};
                        sizex=size(x);
                        if sizex(1)~=0
                            for p=1:sizex(1)
                                for k=1:floor(o/2)
                                    [List_2,nns,NPdata_con]=update_list(chans,fac3,fac2,List_2,sizedata(1),p,o,k,o-k,nns,NPdata_con,base,tax);
                                end
                                Y(ti)=toc-start_con;
                                f1=barh(X,Y)
                                title('Coun Processing time (s)')
                                %saveas(f1,'Coun Processing time.pdf')
                            end
                        end
                        
                    end
                    
                    Y(ti)=toc-start_con;
                    f1=barh(X,Y)
                    title('Coun Processing time (s)')
                    saveas(f1,'Coun Processing time.pdf')
                    
                    % part 3 squeezing and writing
                    %[List_3,last_write_pos]=Squeez_Write(tc,ti,List_2,fac2,filed,base,tax); %error in this line means you have a file with no concurent events
                    [List_3,last_write_pos]=Squeez_Write(tc,ti,List_2,1,file,base,tax,'After Coun'); %error in this line means you have a file with no concurent events
                    
                    Y(ti)=toc-start_con;
                    f1=barh(X,Y)
                    title('Coun Processing time (s)')
                    saveas(f1,'Coun Processing time.pdf')
                    
                    % part 4 classifiacation
                    %[List_4]=Classi(tc,ti,List_3,valu,filed,base,tax,tope,last_write_pos);
                    
                    %str = strcat(tc(ti,1),{'.coun.xlsx'});
                    %filee=[str{:}]
                    %xlswrite(filee,tax','NP','A1');
                    %xlswrite(filee,NPdata_con,'NP','A2');
                    %NPdata_con(NPdata_con~=0)=1; %.))))))))))))))
                    %data_classy(NPdata_con,tax,filee,cutof)%%%%%%%%%%%%%%%
                    
                    
                    
                    
                    str = strcat(tc(ti,1),{'.coun.csv'});
                    %str = strcat(tc(ti,1),{'.csv'});
                    file=[str{:}]
                    tit=el_sim_two(tax);
                    sd = array2table(NPdata_con);
                    sd.Properties.VariableNames=tit;
                    writetable(sd,file,'Delimiter',',')
                    
                    %size_npv_new=size(NPdata_con);
                    %size_npv=size(nev);
                    %if size_npv_new(1)>size_npv(1)
                    %     nev(size_npv(1)+1:size_npv_new(1),:)=0;
                    %end
                    
                    % nev(:,elem_list)=NPdata_con;
                    % tsh=el_sim_two(tx);
                    %tsh=tsh';
                    
                    %b_nev=nev;
                    %b_nev(b_nev>0)=1;
                    %b_nev_sumrow=sum(b_nev,2);
                    %ind_pos=find(b_nev_sumrow>0);
                    % if isempty(ind_pos)
                    %     ind_pos=1;
                    % end
                    % str = strcat(tc(ti,1),{'.NP.csv'});
                    %  %str = strcat(tc(ti,1),{'.csv'});
                    %  file=[str{:}]
                    % tit=el_sim_two(tsh);
                    % sd = array2table(nev(ind_pos,:));
                    % sd.Properties.VariableNames=tit;
                    % writetable(sd,file,'Delimiter',',')
                    
                    
                    Y(ti)=toc-start_con;
                    f1=barh(X,Y)
                    title('Coun Processing time (s)')
                    saveas(f1,'Coun Processing time.pdf')
                end
                %tob=base2dec(tope,3);
                %tobt=num_nam(tob,3,tax);
                %xlswrite(filed,tobt','tope','B1');
                %xlswrite(filed,tob','tope','A2');
                app.CLamp.Color = [0 1 0] ;
                
                xlswrite(filed,{'Concurrency analysis time (s)'},'Read me AIO','A14');
                xlswrite(filed,tc(:,1),'Read me AIO','A15');
                xlswrite(filed,Y','Read me AIO','B15');
                
            end
            xlswrite(filed,{'total time (s)'},'Read me AIO','A13');
            xlswrite(filed,toc,'Read me AIO','B13');
            
            Yy=100
            f4=figure
            X = categorical({'Analysis'});
            X = reordercats(X,{'Analysis'});
            f4=barh(X,Yy)
            title('All analysis (%)')
            saveas(f4,'All analysis.pdf')
            
            
            
            
            app.Lamp.Color = [0 1 0] ;
            %End of code
            
            function [tc]=read_replicate(typ,replicatN,filed)
                tc=[];
                if strcmpi(typ,'h5')
                    filePattern = fullfile('./', '*.h5');
                    files = dir(filePattern);
                    LF=length(files);
                    
                    for ie=1:LF
                        filename = files(ie);
                        c=erase(filename.name,'.h5');
                        tc=cat(1,tc,{c});
                    end
                elseif strcmpi(typ,'csv')
                    filePattern = fullfile('./', '*.csv');
                    files = dir(filePattern);
                    LF=length(files);
                    
                    for ie=1:LF
                        filename = files(ie);
                        c=erase(filename.name,'.csv');
                        tc=cat(1,tc,{c});
                    end
                end
                
                
                tc=reshape(tc',replicatN,[])';
                %xlswrite(filed,tc,'Single Names','A2'); % error happen if the number of file couldnt be reshape in the size which is specifyed for data
                xlswrite(filed,tc,'Filename','B2');
            end
            
            function[tc]=read_file(filed)
                [~,tc]=xlsread(filed,'Filename');
                %tc = reshape(tc',[],1)
                %xlswrite(filed,tc,'Single Names','A2');
            end
            
            function [sample]=Datasize(num,st,ed)
                b=size (num);
                if 0==(st-ed)
                    sample=num;
                elseif and (st<ed,b(1)>=(st-ed))
                    %  dropb1=num(3960:11880,:); % ~8second droplet 50*8=400 drolet
                    sample=num(st:ed,:);
                    %  dropb2=num(1:2,:);
                    
                else
                    error(' Not a suatable file size. try to change start and end data row')
                end
                
            end
            
            function []=writedata(dropb1,sample,dropb2,diss,txt,strn)
                xlswrite([strn{:}],txt,'2-sample')
                xlswrite([strn{:}],sample,'2-sample','A2')
                xlswrite([strn{:}],txt','diss count')
                xlswrite([strn{:}],diss','diss count','B1')
                xlswrite([strn{:}],txt,'1-Droplet burst1')
                xlswrite([strn{:}],dropb1,'1-Droplet burst1','A2')
                xlswrite([strn{:}],txt,'3-Droplet burst2')
                xlswrite([strn{:}],dropb2,'3-Droplet burst2','A2')
            end
            
            function []=NEWwritedata(sample,txt,strn)
                
                stre = strcat(strn,{'.raw.csv'});
                    files=[stre{:}];
                    titll=el_sim(txt);
                    %Allnpv=cat(3,Allnpv,npv);
                    sdw = array2table(sample);
                    sdw.Properties.VariableNames=titll;
                    writetable(sdw,files,'Delimiter',',')
            end
            
            function [num]=usable_data(list,table,listnew,WF)
                sizelist=size(list);
                sizetlistnew=size(listnew);
                sizetable=size(table);
                k=0;
                num=zeros(sizetable(1),sizetlistnew(2));
                
                for id=1:sizetlistnew(2)
                    minilist=give_names(listnew(id));
                    sizeminilist=size(minilist);
                    for y=1:sizeminilist(2)
                        for jd=1:sizelist(1)
                            if isequal(minilist(y),list(jd))
                                num(:,id)=num(:,id)+table(:,jd)*WF;
                                break
                            elseif jd==sizelist(1)
                                el=string(minilist(y));
                                msg=strcat(el,'didnt exist in mass table');
                                error(msg);
                            end
                        end
                    end
                end
            end
            
            function [minilist]=give_names(st)
                stl=st{:};
                x=size(stl);
                plus_position=0;
                minilist={};
                k=0;
                for i=1:x(2)
                    if stl(i)=='+'
                        if i==plus_position(k+1)+1 % correction for more than 1 plus (+)
                            plus_position(end)=i;
                            minilist=minilist(1:end-1);
                            minilist(end+1)=cellstr(stl(1+plus_position(k):plus_position(k+1)));
                        else
                            k=k+1;
                            plus_position(k+1)=i;
                            minilist(end+1)=cellstr(stl(1+plus_position(k):plus_position(k+1)));
                        end
                    end
                end
            end
            
            function [sample,diss,strn,num]= Readtof(typ,strn,listnew,WF,st,ed)
                if strcmpi(typ,'csv')
                    %WF=1; %for CSV assumtion is its already multiplyied by waveform number so we cancel this
                    strn = strcat(strn,{'.csv'});
                    [table,list] = xlsread([strn{:}]);
                    %table=table (:,2:end); %removing the time bin
                    %list=list(2:end); %removing the time bin
                    list=list'; % Because H5 file are this way so we need to keep it constant
                    strn = erase(strn,".csv");
                    %strn = strcat(strn,{'.xlsx'});
                else
                    if strcmpi(typ,'h5')
                        [list,table]=hd5fileread(strn);
                    elseif strcmpi(typ,'Tofware')
                        [list,table]=hd5filereadTofware(strn);
                    else
                        Error=['only ' 'h5 ','csv ','Tofware ','as typ input']
                    end
                end
                
                if WF==0
                    h5_filenamem = [strn '.h5'];
                    %WF=65;
                    WF = h5readatt(h5_filenamem,'/','NbrWaveforms');
                    WF=double(WF);
                end
                
                num=usable_data(list,table,listnew,WF);
                [sample]=Datasize(num,st,ed);
                
                NEWwritedata(sample,listnew,strn);
                
                sample(sample<0)=0; % add for S-TOF issue
                
                %b=size (num)
                %Correction for disslolve signal
                %for i=1:b(2)
                diss=mean(sample,1);
                %dropb1(:,i)=dropb1(:,i)-diss(i);
                %dropb2(:,i)=dropb2(:,i)-diss(i);
                %end
                
                strn = strcat(strn,{'.csv'});
                
                %xlswrite([strn{:}],listnew,'All')
                %csvwrite([strn{:}],listnew,1,1)
                %xlswrite([strn{:}],num,'All','A2')
                %csvwrite([strn{:}],num,1,0)
                
                %dropb1=sample;
                %dropb2=sample;
                %writedata(dropb1,sample,dropb2,diss,listnew,strn)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            end
            
            function [peakList,data]=hd5fileread(h5_filename)
                % hd5fileread function getting a hf file name in the format of {'filename'}
                % and return the data(peaktable) and peaklist of that file
                h5_filename = [h5_filename '.h5']; %[h5_filename{:}]
                data = h5read(h5_filename,'/PeakData/PeakData');
                dh5=size(data);
                data=reshape(data,dh5(1),dh5(3)*dh5(4));
                data=data';
                
                peakTable = h5read(h5_filename,'/PeakData/PeakTable');
                %peakList = peakTable(2,:)';
                peakLabel = peakTable.label';
                peakList = cell(size(peakLabel,1),1);
                NbrMasses = size(peakLabel,1);
                for peak = 1:size(peakLabel,1)
                    % the ASCII <0>/NUL is used to split the string here, therefore char(0)
                    [label, ~] = strsplit(peakLabel(peak,:),char(0)) ;
                    peakList(peak) = label(1);
                end
            end
            
            function [peakList,data]=hd5filereadTofware(h5_filename)
                % hd5fileread function getting a hf file name in the format of {'filename'}
                % and return the data(peaktable) and peaklist of that file
                h5_filename = [h5_filename '.h5']; %[h5_filename{:}]
                data = h5read(h5_filename,'/PeakData/PeakData');
                dh5=size(data);
                data=reshape(data,dh5(1),dh5(3)*dh5(4));
                data=data';
                
                peakTable = h5read(h5_filename,'/PeakData/PeakTable');
                peakList = peakTable(2,:)';
                %peakLabel = peakTable.label';
                %peakList = cell(size(peakLabel,1),1);
                %NbrMasses = size(peakLabel,1);
                %for peak = 1:size(peakLabel,1)
                %    % the ASCII <0>/NUL is used to split the string here, therefore char(0)
                %    [label, ~] = strsplit(peakLabel(peak,:),char(0)) ;
                %    peakList(peak) = label(1);
                %end
            end
            
            function [Binary_split,data_split]=split_correct(name_function,Completed_data,file,txt,Alfat,Scs)
                %'Alfat' is for correcting for the background signal of droplet so if you do further correction it dosent effect but if you already correct for it consider puting zeros
                if strcmpi(name_function,'oneBF')
                    Th1=Threshold(Completed_data, 0.025,file,'sheet2')
                    Th1=Scs;
                    [Binary_detection1,NP_detection1,NP_complete1]=After_Th(Completed_data,Th1,file,txt);
                    [Binary_split,data_split]=Split_oneBF (Binary_detection1,Completed_data,Alfat);
                elseif strcmpi(name_function,'all')
                    %Th1=Threshold(Completed_data, 0.025,file,'split Alfa')
                    Th1=Scs;
                    [Binary_detection1,NP_detection1,NP_complete1]=After_Th(Completed_data,Th1,file,txt);
                    [Binary_split,data_split]=Split_all (Binary_detection1,Completed_data,Alfat);
                elseif strcmpi(name_function,'atleast')
                    %Th1=Threshold(Completed_data, 0.025,file,'split Alfa')
                    Th1=Scs;
                    [Binary_detection1,NP_detection1,NP_complete1]=After_Th(Completed_data,Th1,file,txt);
                    [Binary_split,data_split]=Split_atleast_n (Binary_detection1,Completed_data,Alfat);
                elseif strcmpi(name_function,'elementwise')
                    %Th1=Threshold(Completed_data, 0.025,file,'split Alfa')
                    Th1=Scs;
                    [Binary_detection1,NP_detection1,NP_complete1]=After_Th(Completed_data,Th1,file,txt);
                    [Binary_split,data_split]=Split_elementwise (Binary_detection1,Completed_data,Alfat);
                elseif strcmpi(name_function,'no')
                    %Th1=Threshold(Completed_data, 0.025,file,'split Alfa')
                    Th1=Scs;
                    [Binary_detection1,NP_detection1,NP_complete1]=After_Th(Completed_data,Th1,file,txt);
                    [Binary_split,data_split]=Split_no (Binary_detection1,Completed_data,Alfat);
                else
                    'Error: split correction name was wrong'
                end
            end
            
            
            
            function [Binary_detection,NP_detection]=Split_oneBF (Binary_detection,NP_detection,Th)
                S=size(Binary_detection);
                
                for j=2:S(1)-1
                    for i=S(2):-1:1 %i=1:S(2)
                        if Binary_detection(j,i)==1
                            NP_detection(j,:)= NP_detection(j-1,:)+NP_detection(j,:)+NP_detection(j+1,:)-2*Th(1,:);
                            NP_detection(j-1,:)=0;
                            NP_detection(j+1,:)=0;
                            Binary_detection(j-1,:)=0; % to make sure next line dosent repated
                            Binary_detection(j+1,:)=0; % to make sure next line dosent repated
                            break
                        end
                    end
                    
                end
            end
            
            
            function [Binary_detection,NP_detection]=Split_all (Binary_detection,NP_detection,Th)
                S=size(Binary_detection);
                
                for j=1:S(1)-1
                    for i=S(2):-1:1 %i=1:S(2) bottem up %i=S(2):-1:1 top down %i=S(2):-1:S(2)only last mass
                        if and ((Binary_detection(j,i)==1) , (Binary_detection(j+1,i)==1))
                            NP_detection(j+1,:)= NP_detection(j,:)+NP_detection(j+1,:)-Th(1,:);
                            NP_detection(j,:)=0;
                            Binary_detection(j+1,:)=0; % to make sure next line dosent repated
                            break
                        end
                    end
                    
                end
            end
            
            function [Binary_detection,NP_detection]=Split_atleast_n (Binary_detection,NP_detection,Th)
                % key it this function is N please be arert for now 'n' is not defind outside of the fuction so you need to modify it manually
                S=size(Binary_detection);
                
                for j=1:S(1)-1
                    n=0; %number of split element to do split correction
                    for i=S(2):-1:1
                        if and ((Binary_detection(j,i)==1) , (Binary_detection(j+1,i)==1))
                            n=n+1;
                            if n==3
                                NP_detection(j+1,:)= NP_detection(j,:)+NP_detection(j+1,:)-Th(1,:);
                                NP_detection(j,:)=0;
                                Binary_detection(j+1,:)=0; % to make sure next line dosent repated
                                break
                            end
                        end
                    end
                    
                end
            end
            
            function [Binary_detection,NP_detection]=Split_elementwise (Binary_detection,NP_detection,Th)
                S=size(Binary_detection);
                
                for j=1:S(1)-1
                    for i=1:S(2)
                        if and ((Binary_detection(j,i)==1) , (Binary_detection(j+1,i)==1))
                            %if NP_detection(j,i)>NP_detection(j+1,i) | and(NP_detection(j,i)/NP_detection(j+1,i)<1.3,NP_detection(j,i)/NP_detection(j+1,i)>0.7)
                            if NP_detection(j,i)/NP_detection(j+1,i)>1 % around 95%
                                NP_detection(j,i)= sum(NP_detection(j:j+1,i))-Th(i);
                                NP_detection(j+1,i)=Th(i);%%% added in 26.11.2019 to because the total diss stay the same
                                Binary_detection(j+1,i)=0;
                                Binary_detection(j,i)=-1;
                            else
                                NP_detection(j+1,i)= sum(NP_detection(j:j+1,i))-Th(i);
                                NP_detection(j,i)=Th(i);%%% added in 26.11.2019 to because the total diss stay the same
                                Binary_detection(j+1,i)=-1; % to make sure next line dosent repated
                                Binary_detection(j,i)=0;
                            end
                            
                            %NP_detection(j,:)= sum(NP_detection(j:j+1,:))-Th;
                            %NP_detection(j+1,:)=0;
                            %Binary_detection(j+1,:)=0;
                        end
                    end
                    
                end
            end
            
            
            
            
            function [Binary_detection,NP_detection]=Split_no (Binary_detection,NP_detection,Th)
            end
            
            
            function [Th]=Threshold(Data,Alfa,file,tt)
                %Data=[1,4 75;61,7 2;106 5,16;12 13 54;0 9 6]
                [Th,txt] = xlsread(file,tt);
                Size_txt=size(txt);
                for i=1:Size_txt(2)
                    if Th(i)==0
                        Data_sort=sort(Data(:,i),'descend');
                        S=size (Data_sort);
                        %Alfa=0.013;
                        Th(i)=Data_sort(round(S(1)*Alfa));
                        %Avg_data= mean(Data);
                        %Std_data=std(Data);
                        %Three_sigma=Avg_data+3*Std_data
                        
                        %for i=1:S(2)
                        %    if Three_sigma(i)>Th(i)
                        %Th(i)=Four_sigma(i)
                        %        Th(i)=Three_sigma(i);
                        %    end
                        %end
                    end
                end
                xlswrite(file,Th,tt,'A3');
            end
            
            function [Binary_detection,NP_detection,NP_complete]=After_Th(sample,Th,file,txt)
                %Th=Threshold(sample, Alfa,file)
                S=size(sample);
                Binary_detection=zeros(S);
                NP_detection=zeros(S);
                NP_complete=zeros(S);
                %k=0;
                Binary_single=zeros(1,S(2));
                NP_single=zeros(1,S(2));
                
                for i=1:S(1)
                    for j=1:S(2)
                        if sample(i,j)>=Th(j)
                            Binary_single(j)=1;
                            NP_single(j)=sample(i,j);
                        end
                    end
                    if sum(Binary_single)>0
                        %k=k+1;
                        Binary_detection(i,:)=Binary_single;
                        NP_detection(i,:)=NP_single;
                        NP_complete(i,:)=sample(i,:);
                        Binary_single=zeros(1,S(2));
                        NP_single=zeros(1,S(2));
                    end
                end
                %xlswrite(file,txt,'Binary_detection','A1');
                %xlswrite(file,Binary_detection(1:k,:),'Binary_detection','A2');
                %xlswrite(file,txt,'NP_detection','A1');
                %xlswrite(file,NP_detection(1:k,:),'NP_detection','A2');
                %xlswrite(file,txt,'NP_complete','A1');
                %xlswrite(file,NP_complete(1:k,:),'NP_complete','A2');
            end
            
            function [sumNp,avgNp,TrueDiss,pNp,Np,Binary_detection]=Top_finder(num,data_comp)
                
                data=data_comp;
                Th=num;
                ds=size(data);
                ts=size(Th);
                n=ts(1);
                Np=zeros(ds);
                pNp=zeros(ds);
                Binary_detection=zeros(ds);
                for i=1:n
                    x=data>=Th(i,:);
                    y=sum(x,2);
                    k=y>=i;
                    m=x.*k;
                    Np=Np+(data.*m);
                    Binary_detection=Binary_detection+m;
                    pNp=pNp+m*i;
                    data=data.*(data<Th(i,:));
                end
                sumNp=sum(Binary_detection);
                avgNp= sum(Np)./sumNp;
                TrueDiss=sum(data_comp-Np)./((ds(1)*ones(1,ds(2)))-sumNp);
            end
            
            
            function [Cor_matrix,Cor_p_value]=correlation_coefs (Binary_detection,NP_complete,file,txt)
                bd=Binary_detection;
                bd(bd==0)=nan;
                NP=NP_complete.*bd;
                [Cor_matrix,Cor_p_value]=corrcoef(NP,'Rows','pairwise');
                
                S=size(Binary_detection);
                NpN_matrix=nan(S(2));
                for i=1:S(2)
                    for j=i:S(2)
                        pN=bd(:,i).*bd(:,j);
                        NpN=nansum(pN);
                        NpN_matrix(i,j)=NpN;
                        NpN_matrix(j,i)=NpN;
                    end
                end
                Cor_matrix=round(Cor_matrix,2);
                Cor_p_value=round(Cor_p_value,4);
                
                sizeCompleted_data=size(NP_complete);
                %[con_matrix,des_matrix]=concurrent(NpN_matrix,sizeCompleted_data(1));
                
                
                xlswrite(file,txt,'Cor cof','B2');
                xlswrite(file,txt','Cor cof','A3');
                xlswrite(file,Cor_matrix,'Cor cof','B3');
                %xlswrite(file,txt,'p-value','B2');
                %xlswrite(file,txt','p-value','A3');
                %xlswrite(file,Cor_p_value,'p-value','B3');
                xlswrite(file,txt,'NP Number','B2');
                xlswrite(file,txt','NP Number','A3');
                xlswrite(file,NpN_matrix,'NP Number','B3');
                %xlswrite(file,txt,'Concurrent','B2');
                %xlswrite(file,txt','Concurrent','A3');
                %xlswrite(file,con_matrix,'Concurrent','B3');
                %xlswrite(file,txt,'Con NPN compare','B2');
                %xlswrite(file,txt','Con NPN compare','A3');
                %xlswrite(file,des_matrix,'Con NPN compare','B3');
                
            end
            
            function [con_matrix,des_matrix]=concurrent(NpN_matrix,datasize)
                x=size(NpN_matrix);
                con_matrix=zeros(x(1));
                des_matrix=zeros(x(1));
                for i=1:x(1)
                    for j=i:x(1)
                        if i==j
                            con_matrix(i,j)=NpN_matrix(i,j);
                            des_matrix(j,i)=100;
                        else
                            y=round(NpN_matrix(i,i)*NpN_matrix(j,j)/datasize);
                            con_matrix(i,j)=y;
                            con_matrix(j,i)=y;
                            if NpN_matrix(i,j)>y
                                z=round(100*(NpN_matrix(i,j)-y)/max(NpN_matrix(i,i),NpN_matrix(j,j)));
                            else
                                z=0;
                            end
                            des_matrix(j,i)=z;
                            des_matrix(i,j)=z;
                        end
                    end
                end
                
            end
            function [Data_final,Th,sum_datad,Datad]=Bumper(data,alfa,sumfac,alfac)
                %Data=[1,4 75;61,7 2;106 5,16;12 13 54;0 9 6]
                Datad=data;
                Avg_data=median(data);
                Data_size=size(Datad);
                Data_sort=sort(Datad,1,'descend');
                Th=Data_sort(round(Data_size(1)*alfa),:);
                Datad(Datad<=Th)=0;
                Datad(Datad>Th)=1;
                for i=1:(Data_size(1)-sumfac+1)
                    Datad(i,:)=sum(Datad(i:(i+sumfac-1),:));
                end
                for i=(Data_size(1)-sumfac):Data_size(1)
                    Datad(i,:)=Datad((Data_size(1)-sumfac+1),:);
                end
                x=alfa*sumfac*alfac; %% important facotr
                Datad(Datad<x)=0;
                Datad(Datad>=x)=1;
                sum_datad=sum(Datad);
                Datad_neg=ones(Data_size)-Datad;
                Data_final=data.*Datad_neg+Avg_data.*Datad;
            end
            
            function [Th_final_lamda,Ths_final_value,Th_final_value,Th_final]=Count_to_Gaussian(Total_sample,Th_final_lamda,Ths_final_value,Th_final_value,Count_limit,Th_final)
                x=size(Total_sample);
                
                std_Sample=std(Total_sample,0,1);
                std_Sample=squeeze(std_Sample)'; % Trikey I plan around to make it possible
                ind=find(Th_final_lamda>Count_limit);
                Th_final_value(ind)=Th_final_lamda(ind)+(3*std_Sample(ind));
                Ths_final_value(ind)=Th_final_lamda(ind)+(2.8*std_Sample(ind));
                Th_final(ind)=0;
                
                % desighed on 2020,02,21 to limited the problem of large background on naoparticle detection
            end
            
            function [A1,A2,B1,B2]=exgen(Siz,num)
                pos=(Siz+1)*(num-1);
                A1= strcat('A',num2str(pos+1));
                A2= strcat('A',num2str(pos+2));
                B1= strcat('B',num2str(pos+1));
                B2= strcat('B',num2str(pos+2));
            end
            
            
            
            function [List_3,last_write_pos]=Squeez_Write(tc,ti,List_2,fac2,filed,base,tax,name_add)
                sizelist=size(List_2);
                List_3={};
                she=strcat(name_add,string(ti));
                xlswrite(filed,tc(ti,:),she,'A1');
                for ic=1:sizelist(2)
                    out=List_2{ic};
                    if ~isempty(out)
                        out=sortrows(out,2,'descend');
                        dc=out(:,2);
                        dc(dc<fac2)=0;
                        dc(dc>=fac2)=1; 
                        dcsum=sum(dc);
                        if dcsum>0
                            out=out(1:dcsum,:);
                            List_3{end+1}=out;
                            str=['A' int2str(3*ic)];
                            str=join(str);
                            %she=tc{ti};
                            
                            
                            xlswrite(filed,out(:,2)',she,str);
                            nt=num_nam(out(:,1),base,tax);
                            str=['A' int2str(3*ic-1)];
                            str=join(str);
                            last_write_pos=3*ic;
                            xlswrite(filed,nt',she,str);
                        else
                            out=[];
                            List_3{end+1}=out;
                        end
                    else
                        out=[];
                        List_3{end+1}=out;
                    end
                end
                
            end
            
            function [List_4]=Classi(tc,ti,List_3,valu,filed,base,tax,tope,last_write_pos)
                she=strcat('File row',string(ti));
                sizeList=size(List_3);
                L=sizeList(2);
                List_4={};
                %tope=[]; %move it to the outside of the loop to get unsupervise program
                fili=[];
                while L~=1
                    if ~isempty(List_3{1,L})
                        xu=List_3{1,L};
                        sizexu=size(xu);
                        for i=1:sizexu(1)
                            elm=xu(i,:);
                            [fili,tope,List_4]=give_manin(fili,tope,List_4,elm,base,valu); %core of classifcation
                        end
                    end
                    L=L-1;
                end
                sizeList_6=size(List_4);
                for i=1:sizeList_6(2)
                    dr=List_4{1,i};
                    
                    str=['A' int2str(3*i+last_write_pos+2)];
                    str=join(str);
                    %she=tc{ti};
                    
                    xlswrite(filed,dr(:,2)',she,str);
                    nt=num_nam(dr(:,1),3,tax);
                    str=['A' int2str(3*i+1+last_write_pos)];
                    str=join(str);
                    
                    xlswrite(filed,nt',she,str);
                end
            end
            
                        
            
            function [List_2, layer_data,out,nns]=unic_num(NPdata,fac,base)
                sizennpv=size(NPdata);
                s=zeros(1,sizennpv(2));
                for i =1:sizennpv(2)
                    s(1,i)=base^(i-1);
                    % one example problem with base(4) to produce this example number 11110
                    % 00001
                    % 00101
                    % 01001
                    % 10001
                    %-------
                    % 11110 this mean a false reading for our program (01+01+01+01=10_4)
                end
                xz=NPdata;
                xz(xz>0)=1;
                xzsum=sum(xz,2);
                xzsum_max=max(xzsum);
                layer_data=[];
                List_2={};
                nns=sum(xz.*s,2); % all nanoparticle types
                for i=1:xzsum_max
                    %% this part make a multy layer matrix of each containing 'n' possible element .
                    %% for example matris 1 keep sommthing like 00100 an 10000 and matris 2 keep 00110 10100.
                    %% becarful sometime some 'n' has not existiong in between so if you have 'n' dimation this
                    %%might mean you have more than n possiblity in your n matris since 'n' itself or something
                    %% else does not exist.
                    lm=xzsum;
                    lm(lm~=i)=0;
                    lm(lm==i)=1;
                    kl=xz.*lm;
                    layer_data=cat(3,layer_data,kl);
                    
                    % this part of the code produce a unic frequency array compose of cell each can contain many
                    % possiblity of 'n' element and number of that possiblity.
                    % be carful with 'fac' variable of you change it from 1 then it no longer similar to your top
                    % part of the fucntion and no loger contaions all the pissiblity as it shown if multy layer matrix.
                    
                    
                    as=sum(kl.*s,2);
                    [ii,jj,kk]=unique(as);
                    freq=accumarray(kk,1);
                    %ii=dec2bin(ii);% or dec2base(ii,2) vhange to charactor vector
                    out=[ii(2:end) freq(2:end)]; % here I assume '0' is allway the forst row of each matris so I deleted it
                    if ~isempty(out)
                        out=sortrows(out,2,'descend');
                        dc=out(:,2);
                        dc(dc<fac)=0;
                        dc(dc>=fac)=1; %'fac' is a variable defined by user and it will keep only nanoparticle type which happened equal or more tnan 'fac' times.
                        dcsum=sum(dc);
                        if dcsum>0
                            out=out(1:dcsum,:);
                            List_2{end+1}=out;
                        else
                            out=[];
                            List_2{end+1}=out;
                        end
                    else
                        out=[];
                        List_2{end+1}=out;
                    end
                end
                
            end
            function [List_2,nns,NPdata_con]=update_list(chans,fac3,fac2,List_2,sizedata,row,col,i,j,nns,NPdata_con,base,table)
                a=List_2{i};
                b=List_2{j};
                motherNP=read_list(List_2,row,col,1);
                cheaker=[];
                if or(~isempty(a),~isempty(b))
                    sizea=size(a);
                    sizeb=size(b);
                    for xa=1:sizea
                        for y=1:sizeb
                            jk=read_list(List_2,row,col,2);
                            if and(motherNP==a(xa,1)+b(y,1),jk>0)
                                subtract=round(a(xa,2)*b(y,2)/sizedata,0);
                                if subtract<chans % the fact that a and b was existiong already promissing that by chance at least one from ther both happen cuncurrent so 'subtract' should  be at least 1
                                    subtract=chans;
                                end
                                %valnew=read_list(List_2,row,col,2)-subtract;
                                %jk=read_list(List_2,row,col,2);
                                valnew=subtract+2*sqrt(subtract); % 95% confidence
                                if i==j % a way overcoming the fact that for even size particle like CeLa or YZrThU combinaation of two 1 or two 2 will appeair 2 times
                                    in_cheaker=cheaker(cheaker==a(xa,1));
                                    if isempty(in_cheaker)
                                        cheaker(end+1)=a(xa,1);
                                        cheaker(end+1)=b(y,1);
                                    else
                                        break
                                    end
                                end
                                if and(jk>valnew,(jk-subtract)>=fac2)
                                    %jk
                                    %valnew
                                    %subtract
                                    [NPdata_con,nns]=change_NPlist(NPdata_con,nns,motherNP,a(xa,1),b(y,1),subtract,base,table);
                                    [List_2]=change_list(List_2,row,col,jk-subtract);
                                    [List_2]=change_list(List_2,xa,i,a(xa,2)+subtract);
                                    [List_2]=change_list(List_2,y,j,b(y,2)+subtract);
                                    
                                else
                                    %if jk>0
                                    [NPdata_con,nns]=change_NPlist(NPdata_con,nns,motherNP,a(xa,1),b(y,1),jk,base,table);
                                    %end
                                    [List_2]=change_list(List_2,row,col,0);
                                    %valnew=read_list(List_2,row,col,2);
                                    [List_2]=change_list(List_2,xa,i,a(xa,2)+jk);
                                    [List_2]=change_list(List_2,y,j,b(y,2)+jk);
                                    
                                end
                            end
                        end
                    end
                    
                end
            end
            
            function [NPlist,nns]=change_NPlist(NPlist,nns,motherNP,a,b,sub,base,table)
                ind=find(nns==motherNP);
                list_to_change=NPlist(ind,:);
                ind_dec=decision_divide (list_to_change,ind,a,b,sub);
                [NPlist,nns]=divider(NPlist,nns,ind_dec,a,b,base,table);
            end
            function [ind_dec]=decision_divide (list_to_change,ind,a,b,sub)
                %ind_dec=ind(1:sub);%%
                
                %% 2way
                d=median(list_to_change,1);%
                inde=find(d == max(d),1);%
                f=list_to_change./list_to_change(:,inde);%
                sumbn=sum(f,2);%
                sumbn=abs(sumbn-median(sumbn));%
                x=cat(2,sumbn,ind);%
                cvs=sortrows(x,'descend');%
                ind_dec=cvs(1:sub,2);%
                
            end
            
            function [NPlist,nns]=divider(NPlist,nns,ind_dec,a,b,base,table)
                lentab=length(table);
                arr=num_array(a,base,table);
                brr=ones(1,lentab)-arr;
                brrd=NPlist(ind_dec,:).*brr;
                NPlist(ind_dec,:)=NPlist(ind_dec,:).*arr;
                NPlist=cat(1,NPlist,brrd);
                nns(ind_dec)=a;
                brre=ind_dec; % just becase they have similar size
                brre(brre~=b)=b;
                nns=cat(1,nns,brre);
            end
            
            
            function [List_2]=change_list(List_2,row,col,val)
                x=List_2{col};
                x(row,2)=val;
                List_2(col)={x};
            end
            function [result]=read_list(List_2,row,col,val)
                x=List_2{col};
                result=x(row,val);
            end
            
            function [arr]=num_array(num,base,table)
                % input an array of num. output transfer to the matrix of 1 and 0
                c=dec2base(num,base);
                c=cellstr(c);
                sizec=size(c);
                arr=[];
                szt=length(table);
                for j=1:sizec(1)
                    
                    tb=c{j};
                    
                    sizetb=size(tb);
                    %lentab=size(table)
                    ar=zeros(1,szt);
                    for i=sizetb(2):-1:1
                        if tb(i)=='1'
                            ar(1,sizetb(2)-i+1)=1;
                        end
                    end
                    arr=cat(1,arr,ar);
                end
            end
            
            
            
            function [strf]=num_nam(num,base,table)
                c=dec2base(num,base);
                c=cellstr(c);
                sizec=size(c);
                strf=[];
                for j=1:sizec(1)
                    
                    tb=c{j};
                    
                    sizetb=size(tb);
                    %lentab=size(table)
                    str='';
                    for i=sizetb(2):-1:1
                        if tb(i)=='1'
                            str=strcat(str,table(sizetb(2)-i+1));
                        end
                    end
                    strf=cat(1,strf,str);
                end
            end
            
            function [table_name]=el_sim(tab)
                lentab=length(tab);
                match = ["[",']','0','1','2','3','4','5','6','7','8','9'];
                table_name=[];
                for i=1:lentab
                    x=tab{i};
                    [ii,jj,kk]=unique(x);
                    ii=erase(ii,match);
                    table_name=cat(1,table_name,{ii});
                end
                
            end
            
            function [table_name]=el_sim_two(tab)
                lentab=length(tab);
                match = ["[",']','0','1','2','3','4','5','6','7','8','9','+'];
                table_name=[];
                for i=1:lentab
                    x=tab{i};
                    [ii,jj,kk]=unique(x);
                    ii=erase(ii,match);
                    table_name=cat(1,table_name,{ii});
                end
                
            end
            
            function [fili,tope,List_6]=give_manin(fili,tope,List_6,elm,base,val)
                pos=0;
                
                sizetope=size(tope);
                ele=dec2base(elm(1,1),base);
                
                if sizetope(2)==0
                    
                    tope=cat(2,tope,{ele});
                    List_6=cat(2,List_6,{elm});
                    fili=cat(2,fili,1);
                    
                else
                    
                    for i=1:sizetope(2)
                        le=length(ele);
                        t=tope{i};
                        lt=length(t);
                        pt=0;
                        le1=0;
                        for j=1:le
                            if lt<le
                                zee(1,1:le-lt)='0';
                                t=cat(2,zee,t);
                                lt=le;
                            end
                            if ele(end-j+1)=='1'
                                le1=le1+1;
                                if ele(end-j+1)==t(end-j+1)
                                    pt=pt+1;
                                else                %this else addedin 20.01.07 in order to put negative weight on not similar element
                                    pt=pt-0.5;
                                end
                            end
                        end
                        val2=pt/le1;
                        if val2>val %main decition
                            val=val2;
                            pos=i;
                        end
                    end
                    
                    
                    if pos==0
                        
                        tope=cat(2,tope,{ele});
                        List_6=cat(2,List_6,{elm});
                        pos=length(tope);
                        fili=cat(2,fili,pos);
                        
                    else
                        
                        sL6=size(List_6);
                        
                        if sL6(2)==0
                            fili=cat(2,fili,pos);
                            List_6=cat(2,List_6,{elm});
                            
                        else
                            posi=find(fili==pos,1);
                            if isempty(posi)
                                
                                List_6=cat(2,List_6,{elm});
                                %pos=length(tope);
                                fili=cat(2,fili,pos);
                            else
                                List_6{1,posi}=cat(1,List_6{1,posi},elm);
                            end
                            
                        end
                        
                    end
                end
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Classy Linkage
            
            function data_classy(NPdata_con,tax,file,cutof)
                hoof=NPdata_con;
                hoof(hoof>0)=1;
                sg=sum(hoof,2);
                ind=find(sg>1);
                good_NP=NPdata_con(ind,:);
                %Binary_good_NP=good_NP;%%%%
                %Binary_good_NP(Binary_good_NP==0)=3.5;%%%%%
                %Binary_good_NP=log(Binary_good_NP)/log(3.5);%%%%%%%
                sizg=size(good_NP)
                if sizg(1)>1
                    Z = linkage(good_NP,'average','correlation');%%%%%% Binary_
                    
                    %fx=20;
                    %c = cluster(Z,'Maxclust',20); in case of fixed number of classes
                    c = cluster(Z,'Cutoff',cutof,'criterion','distance');
                    %c = cluster(Z,'maxclust',cutof);
                    %[c,f] = kmeans(good_NP,cutof,'Distance','correlation');%%%%
                    fx=max(c);
                    histogram(c)
                    if fx<30
                        %class_store=[];
                        for i=1:fx
                            inde=find(c==i);
                            df=good_NP(inde,:);
                            sheetname=strcat('class ',num2str(i));
                            [nmedian,sumNP,sumbinary_Chance]=correlation_coefs_modified(df,file,tax',[sheetname,' sum']);
                            xlswrite(file,df,sheetname,'A2');
                            xlswrite(file,tax',sheetname,'A1');
                            %classD=nmedian;
                            %classD=cat(3,classD,sumNP);
                            %classD=cat(3,classD,sumbinary_Chance);
                        end
                        %class_store=cat(1,class_store,classD);
                        %xlswrite(file,tax','NP','A1');
                        %xlswrite(file,NPdata_con,'NP','A2');
                    else
                        error='you have more than 30 class so it didnt store them in'
                    end
                end
            end
            
            function [nmedian,sumNP,sumbinary_Chance]=correlation_coefs_modified (NPD,file,txt,Class_name)
                %adopted from AOI V7.1 on 2020.02.28 and changed
                Binary_detection=NPD;
                Binary_detection(Binary_detection>0)=1;
                
                
                S=size(Binary_detection);
                sumbinary=sum(Binary_detection,1);
                sumbinary_Chance=sumbinary/S(1)*100;
                
                bd=Binary_detection;
                bd(bd==0)=nan;
                NP=NPD.*bd;
                [Cor_matrix,Cor_p_value]=corrcoef(NP,'Rows','pairwise');
                
                S=size(Binary_detection);
                NpN_matrix=nan(S(2));
                for i=1:S(2)
                    for j=i:S(2)
                        pN=bd(:,i).*bd(:,j);
                        NpN=nansum(pN);
                        NpN_matrix(i,j)=NpN;
                        NpN_matrix(j,i)=NpN;
                    end
                end
                Cor_matrix=round(Cor_matrix,2);
                Cor_p_value=round(Cor_p_value,4);
                
                nmedian=nanmedian(NP,1);
                sumNP=sum(Binary_detection,1);
                
                Bomb=[{'number'},txt,{'Corelation'},txt];
                sumbinary_Chance=round(sumbinary_Chance,2);
                
                Bomb_data=NpN_matrix;
                Bomb_data=cat(2,Bomb_data,nan(S(2),1));
                if S(1)>1
                    Bomb_data=cat(2,Bomb_data,Cor_matrix);
                end
                xlswrite(file,txt,Class_name,'B1');
                xlswrite(file,Bomb,Class_name,'A6');
                xlswrite(file,{'Median nanzero';'SumNP';'Presence(%)'},Class_name,'A2');
                xlswrite(file,nmedian,Class_name,'B2');
                xlswrite(file,sumNP,Class_name,'B3');
                xlswrite(file,sumbinary_Chance,Class_name,'B4');
                
                xlswrite(file,txt',Class_name,'A7');
                xlswrite(file,Bomb_data,Class_name,'B7');
            end
            
            function [npv_new,tax,elem_list]=select_Concurency(npv,tx,udt,mec)
                b_nev=npv;
                b_nev(b_nev>0)=1;
                sum_b_nev=sum(b_nev);
                [out,idx] = sort(sum_b_nev,'descend');
                
                xs=find(out>udt); % find elements with more than "udt" event
                
                size_xs=length(xs);
                if size_xs<=mec
                    elem_list=idx(xs);
                else
                    elem_list=idx(xs(1:mec));
                end
                
                npv_new=npv(:,elem_list);
                tax=el_sim(tx(elem_list,1));
                
            end
            
            
            
            
        end

        % Value changed function: SummarySwitch
        function SummarySwitchValueChanged(app, event)
            %value = app.SummarySwitch.Value;
            if strcmp(app.SummarySwitch.Value, 'Yes')
                app.SLamp.Color = [1 1 1] ;
            else
                app.SLamp.Color = [0.65 0.65 0.65] ;
            end
        end

        % Value changed function: DetectionSwitch
        function DetectionSwitchValueChanged(app, event)
            %value = app.DetectionSwitch.Value;
            if strcmp(app.DetectionSwitch.Value, 'Yes')
                app.DLamp.Color = [1 1 1] ;
            else
                app.DLamp.Color = [0.65 0.65 0.65] ;
            end
        end

        % Value changed function: ConcurrencySwitch
        function ConcurrencySwitchValueChanged(app, event)
            %value = app.ConcurrencySwitch.Value;
            if strcmp(app.ConcurrencySwitch.Value, 'Yes')
                app.CLamp.Color = [1 1 1] ;
            else
                app.CLamp.Color = [0.65 0.65 0.65] ;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 339 679];
            app.UIFigure.Name = 'MATLAB App';

            % Create SummarySwitchLabel
            app.SummarySwitchLabel = uilabel(app.UIFigure);
            app.SummarySwitchLabel.HorizontalAlignment = 'center';
            app.SummarySwitchLabel.Position = [17 233 57 30];
            app.SummarySwitchLabel.Text = 'Summary';

            % Create SummarySwitch
            app.SummarySwitch = uiswitch(app.UIFigure, 'slider');
            app.SummarySwitch.Items = {'No', 'Yes'};
            app.SummarySwitch.ValueChangedFcn = createCallbackFcn(app, @SummarySwitchValueChanged, true);
            app.SummarySwitch.Position = [122 240 52 23];
            app.SummarySwitch.Value = 'Yes';

            % Create RunButton
            app.RunButton = uibutton(app.UIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.FontSize = 14;
            app.RunButton.FontWeight = 'bold';
            app.RunButton.Position = [85 21 100 100];
            app.RunButton.Text = 'Run';

            % Create Integration_windowEditFieldLabel
            app.Integration_windowEditFieldLabel = uilabel(app.UIFigure);
            app.Integration_windowEditFieldLabel.HorizontalAlignment = 'right';
            app.Integration_windowEditFieldLabel.Position = [67 579 109 22];
            app.Integration_windowEditFieldLabel.Text = 'Integration_window';

            % Create Integration_windowEditField
            app.Integration_windowEditField = uieditfield(app.UIFigure, 'numeric');
            app.Integration_windowEditField.Position = [191 579 100 22];

            % Create Least_countEditFieldLabel
            app.Least_countEditFieldLabel = uilabel(app.UIFigure);
            app.Least_countEditFieldLabel.HorizontalAlignment = 'right';
            app.Least_countEditFieldLabel.Position = [105 539 71 22];
            app.Least_countEditFieldLabel.Text = 'Least_count';

            % Create Least_countEditField
            app.Least_countEditField = uieditfield(app.UIFigure, 'numeric');
            app.Least_countEditField.Position = [191 539 100 22];
            app.Least_countEditField.Value = 3.5;

            % Create NanoparticletonoiseEditFieldLabel
            app.NanoparticletonoiseEditFieldLabel = uilabel(app.UIFigure);
            app.NanoparticletonoiseEditFieldLabel.HorizontalAlignment = 'right';
            app.NanoparticletonoiseEditFieldLabel.Position = [58 499 118 22];
            app.NanoparticletonoiseEditFieldLabel.Text = 'Nanoparticle to noise';

            % Create NanoparticletonoiseEditField
            app.NanoparticletonoiseEditField = uieditfield(app.UIFigure, 'numeric');
            app.NanoparticletonoiseEditField.Position = [191 499 100 22];
            app.NanoparticletonoiseEditField.Value = 40;

            % Create Smooth_windowEditFieldLabel
            app.Smooth_windowEditFieldLabel = uilabel(app.UIFigure);
            app.Smooth_windowEditFieldLabel.HorizontalAlignment = 'right';
            app.Smooth_windowEditFieldLabel.Position = [82 459 94 22];
            app.Smooth_windowEditFieldLabel.Text = 'Smooth_window';

            % Create Smooth_windowEditField
            app.Smooth_windowEditField = uieditfield(app.UIFigure, 'numeric');
            app.Smooth_windowEditField.Position = [191 459 100 22];
            app.Smooth_windowEditField.Value = 50;

            % Create StartdatapointrownumberEditFieldLabel
            app.StartdatapointrownumberEditFieldLabel = uilabel(app.UIFigure);
            app.StartdatapointrownumberEditFieldLabel.HorizontalAlignment = 'right';
            app.StartdatapointrownumberEditFieldLabel.Position = [22 419 154 22];
            app.StartdatapointrownumberEditFieldLabel.Text = 'Start data point row number';

            % Create StartdatapointrownumberEditField
            app.StartdatapointrownumberEditField = uieditfield(app.UIFigure, 'numeric');
            app.StartdatapointrownumberEditField.Position = [191 419 100 22];

            % Create InputdataformatDropDownLabel
            app.InputdataformatDropDownLabel = uilabel(app.UIFigure);
            app.InputdataformatDropDownLabel.HorizontalAlignment = 'right';
            app.InputdataformatDropDownLabel.Position = [81 308 96 22];
            app.InputdataformatDropDownLabel.Text = 'Input data format';

            % Create InputdataformatDropDown
            app.InputdataformatDropDown = uidropdown(app.UIFigure);
            app.InputdataformatDropDown.Items = {'h5', 'CSV', ''};
            app.InputdataformatDropDown.Position = [192 308 100 22];
            app.InputdataformatDropDown.Value = 'h5';

            % Create EnddatapointrownumberEditFieldLabel
            app.EnddatapointrownumberEditFieldLabel = uilabel(app.UIFigure);
            app.EnddatapointrownumberEditFieldLabel.HorizontalAlignment = 'right';
            app.EnddatapointrownumberEditFieldLabel.Position = [26 379 150 22];
            app.EnddatapointrownumberEditFieldLabel.Text = 'End data point row number';

            % Create EnddatapointrownumberEditField
            app.EnddatapointrownumberEditField = uieditfield(app.UIFigure, 'numeric');
            app.EnddatapointrownumberEditField.Position = [191 379 100 22];

            % Create NumberofreplicatesEditFieldLabel
            app.NumberofreplicatesEditFieldLabel = uilabel(app.UIFigure);
            app.NumberofreplicatesEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofreplicatesEditFieldLabel.Position = [60 339 116 22];
            app.NumberofreplicatesEditFieldLabel.Text = 'Number of replicates';

            % Create NumberofreplicatesEditField
            app.NumberofreplicatesEditField = uieditfield(app.UIFigure, 'numeric');
            app.NumberofreplicatesEditField.Position = [191 339 100 22];
            app.NumberofreplicatesEditField.Value = 1;

            % Create ReadsettingfromfileSwitchLabel
            app.ReadsettingfromfileSwitchLabel = uilabel(app.UIFigure);
            app.ReadsettingfromfileSwitchLabel.HorizontalAlignment = 'center';
            app.ReadsettingfromfileSwitchLabel.Position = [53 624 119 22];
            app.ReadsettingfromfileSwitchLabel.Text = 'Read setting from file';

            % Create ReadsettingfromfileSwitch
            app.ReadsettingfromfileSwitch = uiswitch(app.UIFigure, 'slider');
            app.ReadsettingfromfileSwitch.Items = {'No', 'Yes'};
            app.ReadsettingfromfileSwitch.Position = [205 619 73 32];
            app.ReadsettingfromfileSwitch.Value = 'No';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [218 21 100 100];
            app.Image.ImageSource = 'splash.png';

            % Create DLampLabel
            app.DLampLabel = uilabel(app.UIFigure);
            app.DLampLabel.HorizontalAlignment = 'right';
            app.DLampLabel.Position = [258 278 25 22];
            app.DLampLabel.Text = 'D';

            % Create DLamp
            app.DLamp = uilamp(app.UIFigure);
            app.DLamp.Position = [298 278 20 20];
            app.DLamp.Color = [0.651 0.651 0.651];

            % Create SLampLabel
            app.SLampLabel = uilabel(app.UIFigure);
            app.SLampLabel.HorizontalAlignment = 'right';
            app.SLampLabel.Position = [258 237 25 22];
            app.SLampLabel.Text = 'S';

            % Create SLamp
            app.SLamp = uilamp(app.UIFigure);
            app.SLamp.Position = [298 236 20 20];
            app.SLamp.Color = [0.651 0.651 0.651];

            % Create CLampLabel
            app.CLampLabel = uilabel(app.UIFigure);
            app.CLampLabel.HorizontalAlignment = 'right';
            app.CLampLabel.Position = [258 194 25 22];
            app.CLampLabel.Text = 'C';

            % Create CLamp
            app.CLamp = uilamp(app.UIFigure);
            app.CLamp.Position = [298 194 20 20];
            app.CLamp.Color = [0.651 0.651 0.651];

            % Create DetectionSwitchLabel
            app.DetectionSwitchLabel = uilabel(app.UIFigure);
            app.DetectionSwitchLabel.HorizontalAlignment = 'center';
            app.DetectionSwitchLabel.Position = [16 280 56 22];
            app.DetectionSwitchLabel.Text = 'Detection';

            % Create DetectionSwitch
            app.DetectionSwitch = uiswitch(app.UIFigure, 'slider');
            app.DetectionSwitch.Items = {'No', 'Yes'};
            app.DetectionSwitch.ValueChangedFcn = createCallbackFcn(app, @DetectionSwitchValueChanged, true);
            app.DetectionSwitch.Position = [122 277 52 23];
            app.DetectionSwitch.Value = 'Yes';

            % Create ConcurrencySwitchLabel
            app.ConcurrencySwitchLabel = uilabel(app.UIFigure);
            app.ConcurrencySwitchLabel.HorizontalAlignment = 'center';
            app.ConcurrencySwitchLabel.Position = [9 190 74 30];
            app.ConcurrencySwitchLabel.Text = 'Concurrency';

            % Create ConcurrencySwitch
            app.ConcurrencySwitch = uiswitch(app.UIFigure, 'slider');
            app.ConcurrencySwitch.Items = {'No', 'Yes'};
            app.ConcurrencySwitch.ValueChangedFcn = createCallbackFcn(app, @ConcurrencySwitchValueChanged, true);
            app.ConcurrencySwitch.Position = [122 197 52 23];
            app.ConcurrencySwitch.Value = 'Yes';

            % Create Lamp
            app.Lamp = uilamp(app.UIFigure);
            app.Lamp.Position = [239 92 18 18];
            app.Lamp.Color = [1 1 1];

            % Create ClusteringSwitchLabel
            app.ClusteringSwitchLabel = uilabel(app.UIFigure);
            app.ClusteringSwitchLabel.HorizontalAlignment = 'center';
            app.ClusteringSwitchLabel.Position = [10 145 74 30];
            app.ClusteringSwitchLabel.Text = 'Clustering';

            % Create ClusteringSwitch
            app.ClusteringSwitch = uiswitch(app.UIFigure, 'slider');
            app.ClusteringSwitch.Items = {'No', 'Yes'};
            app.ClusteringSwitch.Position = [123 152 52 23];
            app.ClusteringSwitch.Value = 'Yes';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = NanoFinder

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

