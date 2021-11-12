    % Author: Kamyar Mehrabi Kochehbyoki/ https://gitHub.com/kammk 
    % GitHub repository of the program: https://github.com/ethz-tema/TEMAsingleparticle
    % Email: kamyarm@ethz.ch
    % Release date 2021.03.01
    % Version NanoFinder V5.6
    % Open access licence by ETH Zürich
    
classdef NanoFinder < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        NanoFinder559Label              matlab.ui.control.Label
        SISLamp                         matlab.ui.control.Lamp
        SISLampLabel                    matlab.ui.control.Label
        HCLamp                          matlab.ui.control.Lamp
        HCLampLabel                     matlab.ui.control.Label
        QuantClusteringSwitch           matlab.ui.control.Switch
        QuantClusteringSwitchLabel      matlab.ui.control.Label
        Lamp                            matlab.ui.control.Lamp
        hpCCSwitch                      matlab.ui.control.Switch
        hpCCSwitchLabel                 matlab.ui.control.Label
        DetectionSwitch                 matlab.ui.control.Switch
        DetectionSwitchLabel            matlab.ui.control.Label
        CLamp                           matlab.ui.control.Lamp
        CLampLabel                      matlab.ui.control.Label
        SLamp                           matlab.ui.control.Lamp
        SLampLabel                      matlab.ui.control.Label
        DLamp                           matlab.ui.control.Lamp
        DLampLabel                      matlab.ui.control.Label
        Image                           matlab.ui.control.Image
        ReadsettingfromExcelMDEFSwitch  matlab.ui.control.Switch
        ReadsettingfromExcelMDEFSwitchLabel  matlab.ui.control.Label
        NumberofRunspersampleEditField  matlab.ui.control.NumericEditField
        NumberofRunspersampleEditFieldLabel  matlab.ui.control.Label
        EnddatapointEditField           matlab.ui.control.NumericEditField
        EnddatapointEditFieldLabel      matlab.ui.control.Label
        Datafileformath5orcsvDropDown   matlab.ui.control.DropDown
        Datafileformath5orcsvDropDownLabel  matlab.ui.control.Label
        StartdatapointEditField         matlab.ui.control.NumericEditField
        StartdatapointEditFieldLabel    matlab.ui.control.Label
        SmoothingwindowEditField        matlab.ui.control.NumericEditField
        SmoothingwindowEditFieldLabel   matlab.ui.control.Label
        TruetofalsepositiveratioEditField  matlab.ui.control.NumericEditField
        TruetofalsepositiveratioEditFieldLabel  matlab.ui.control.Label
        ThresholdlowerboundaryEditField  matlab.ui.control.NumericEditField
        ThresholdlowerboundaryEditFieldLabel  matlab.ui.control.Label
        ConversionfactortocountsEditField  matlab.ui.control.NumericEditField
        ConversionfactortocountsEditFieldLabel  matlab.ui.control.Label
        RunButton                       matlab.ui.control.Button
        SummarySwitch                   matlab.ui.control.Switch
        SummarySwitchLabel              matlab.ui.control.Label
    end

    %Kamyar Mehrabi 2021.11.12

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
            app.Lamp.Color = [1 0 0] ;
            
            tic
            app.NanoFinder559Label.Text
            [filed,path] = uigetfile('../*.xlsx');
            cd (path)
            
            [tc]=read_file(filed);
            tc=tc(2:end,:);
            [nsh,tx] = xlsread(filed,'Elements');
            List_Elem=tx;
            size_tx=size(tx)
            sab=[];
            for ihat=1:size_tx(1)
                sab=cat(2,sab,{[tx{ihat,:}]});
            end
            tx=sab;
            
            
            sumy='No';
            if strcmp(app.SummarySwitch.Value, 'Yes')
                sumy='Yes';
            end
            
            Detect='No';
            if strcmp(app.DetectionSwitch.Value, 'Yes')
                Detect='Yes';
            end
            
            conc='No';
            if strcmp(app.hpCCSwitch.Value, 'Yes')
                conc='Yes';
            end
            
            Clus_switch='No';
            if strcmp(app. QuantClusteringSwitch.Value, 'Yes')
                Clus_switch='Yes';
            end
            
            if strcmpi(Detect,'yes')
                app.DLamp.Color = [1 0 0] ;
                if strcmp(app.ReadsettingfromExcelMDEFSwitch.Value, 'No')
                    
                    
                    typ='h5';
                    if strcmp(app.Datafileformath5orcsvDropDown.Value, 'CSV')
                        typ='CSV';
                    end
                    WF=app.ConversionfactortocountsEditField.Value;
                    limit=app.ThresholdlowerboundaryEditField.Value;
                    Goldnum=app.TruetofalsepositiveratioEditField.Value;
                    smooth_window=app.SmoothingwindowEditField.Value;
                    st=app.StartdatapointEditField.Value;
                    ed=app.EnddatapointEditField.Value;
                    replicatN=app.NumberofRunspersampleEditField.Value;
                    if replicatN==0
                        replicatN=1;
                    end
                else
                    
                    [nm,tm]=xlsread(filed,'Read me AIO');
                    WF=nm(1,1);
                    limit=nm(2,1);
                    Goldnum=nm(3,1);
                    smooth_window=nm(4,1);
                    st=nm(5,1);
                    ed=nm(6,1);
                    if length(nm)>=7
                        replicatN=nm(7,1);
                    else
                        replicatN=1;
                    end
                    typ=tm{8,2};
                end
                
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
                
                
                [nl,txl] = xlsread(filed,'Line');
                nl_sz=size(nl);
                if nl_sz(2)==1
                    app.SISLamp.Color = [1 0 0] ;
                    pause(1)
                    SIS_Line_exp(filed);
                    [nl,txl] = xlsread(filed,'Line');
                end
                app.SISLamp.Color = [0 1 0] ;
                
                
                tc_new=itc;
                tc=otc;
                
                tcsize=size(tc_new)
                Y=zeros([1,tcsize(1)]);
                f1=figure;
                X = categorical(tc(:,1));
                X = reordercats(X,tc(:,1));
                f1=barh(X,Y) % Error here is due to the name replicate number
                title('reading data (%)');
                saveas(f1,'reading data AIO.pdf');
                
                tsh=el_sim_two(tx);
                tsh=tsh';
                Total_sample=[];
                Total_drp1=[];
                Total_diss=[];
                Completed_newlamda=[];
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Reading the data
                
                for ia=1:tcsize(1)

                    Completed_data=[];
                    Completed_drp1=[];
                    Completed_diss=[];
                    newlamda=[];
                    for fh=1:d(ia) %for the number of columns in filename this loop will be repeated%
                        strn=tc_new{ia,fh}
                        [sample,diss,strn,WF,st,ed]= Readtof(typ,strn,List_Elem,WF,st,ed);
     
                        
                        % smooth the data
                        samp=smoothdata(sample,'movmedian',smooth_window);
                        avy=mean(samp);
                        sample=sample-samp+avy;
                        Completed_data=cat(1,Completed_data,sample);
                        Completed_diss=cat(1,Completed_diss,diss);
                        newlamda=cat(1,newlamda,avy);
                    end

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
                xlswrite(filed,[{'Conversion factor to counts'},{'Threshold lower boundary'},{'True to false positive ratio'},{'Smoothing window'},{'Start data point'},{'End data point'},{'Number of Runs per sample'}, ...
                    {'Data file format (h5 or csv)'},{'Detection'},{'Summary'},{'Concurrency'},{'Quantification and clustering'},{'Date of processing'}]','Read me AIO','A1');
                xlswrite(filed,[WF,limit,Goldnum,smooth_window,st,ed,replicatN,typ,Detect,sumy,conc,Clus_switch,{date}]','Read me AIO','B1');
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Thresholding S_c S_c_s
                
                Y=zeros([1,2]);
                f2=figure;
                X = categorical({'Thresholding','Detection'});
                X = reordercats(X,{'Thresholding','Detection'});
                f2=barh(X,Y);
                title('Processing data (%)');
                saveas(f2,'Processing data AIO.pdf');
                
                lsize=size(nl);
                Thpos=[];
                Thpos_value=[];
                Thpos_lamda=[];
                Thspos_value=[];
                size_data=size(Total_sample);
                rd=sort(Total_sample,1,'descend');
                for ig=1:lsize(1)+1 % Changed on 2021.06.21
                    if ig==lsize(1)+1
                        gg=lsize(1);
                        sd=rd(:,:,:); %%% Changed on 2020.07.07
                    else
                        gg=ig;
                        sd=rd(1+ceil(2*size_data(1)* nl(gg,1)*Goldnum):end,:,:); %%% Changed on 2020.07.07
                    end
                    
                    Y(1)=Y(1)+(100/(lsize(1)+1)/2)
                    f2=barh(X,Y)
                    title('Processing data (%)')
                    drawnow
                    saveas(f2,'Processing data AIO.pdf')
                    
                    slope=nl(gg,2);
                    incp=nl(gg,3);
                    slopes=nl(gg,5);
                    incps=nl(gg,6);
                    sumnpp=[];
                    
                    

                    lamda = squeeze(mean(sd,1));
                    lamda=reshape(lamda,[],tcsize(1));
                    lamda(lamda<0)=0;
                    Sc=lamda+(slope*sqrt(lamda))+incp;% Sc is included lamda so it not Lc
                    Lc=Sc-lamda;
                    ind_lim_Lc=find(Lc<limit);
                    limit_lamda=limit+lamda;
                    Sc(ind_lim_Lc)=limit_lamda(ind_lim_Lc);
                    Sc=reshape(Sc,[],tcsize(1));
                    Scs=lamda+(slopes'.*sqrt(lamda))+incps';
                    Lcs=Scs-lamda;
                    ind_lim_Lcs=find(Lcs<limit);
                    Scs(ind_lim_Lcs)=limit_lamda(ind_lim_Lcs);
                    Scs=reshape(Scs,[],tcsize(1));
                    for ja=1:tcsize(1)
                        
                        name_function='elementwise';
                        str = strcat(tc(ja,1),{'.xlsx'});
                        file=[str{:}];

                        [~,data_split_one]=split_correct(name_function,Total_sample(:,:,ja),file,tsh,lamda(:,ja)',Scs(:,ja)');
                        
                        [sumNp,avgNp,TrueDiss,npp,npv,Binary_detection]=Top_finder(Sc(:,ja)',data_split_one);
                        x=sum(npp,1);
                        sumnpp=cat(1,sumnpp,x);
                    end
                    sumnpp=sumnpp/(2*size_data(1)*nl(gg,1)); % The number of detected nanoparticle devided by number of false positive
                    Thpos=cat(3,Thpos,sumnpp);
                    Thpos_value=cat(3,Thpos_value,Sc');
                    Thspos_value=cat(3,Thspos_value,Scs');
                    Thpos_lamda=cat(3,Thpos_lamda,lamda');
                    
                    Y(1)=Y(1)+(100/(lsize(1)+1)/2)
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
                            if Thpos(id,jd,kd)>Goldnum % important decision
                                Th_final(id,jd)=kd;
                                Th_final_value(id,jd)=Thpos_value(id,jd,kd);
                                Ths_final_value(id,jd)=Thspos_value(id,jd,kd);
                                Th_final_lamda(id,jd)=Thpos_lamda(id,jd,kd); %erro in this line is due to the fact you only have one row of file name in your Filename please increase it to altesat2
                                break
                            else
                                if kd==Thpos_size(3)
                                    Th_final(id,jd)=-kd+1;% need to be modiey "what if there were no particles!!?"
                                    Th_final_value(id,jd)=Thpos_value(id,jd,kd);
                                    Ths_final_value(id,jd)=Thspos_value(id,jd,kd);
                                    Th_final_lamda(id,jd)=Thpos_lamda(id,jd,kd);
                                    
                                end
                            end
                            
                        end
                    end
                end

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
                    xlswrite(file,[{'Avg raw signal_counts'};{'Lambda_counts'};{'TrueDiss_counts'};{'Avg NP_counts'};{'Med NP_counts'};{'Total NP'};{'FALSE POSITIVE Estimation'};{'Lc_Critical value_counts'};{'Sc_Threshold_counts'};{'Scs_Threshold split_counts'};{'FALSE POSITIVE level'};{'split_events'}],'Avg','A2');
                    xlswrite(file,tsh,'Avg','B1');
                    xlswrite(file,[Total_diss(:,ib)';Th_final_lamda(ib,:);TrueDiss;avgNp;medNP;sumNp;sumNpFP;(Th_final_value(ib,:)-TrueDiss);Th_final_value(ib,:);Ths_final_value(ib,:);Th_final(ib,:);split_event_count],'Avg','B2');

                    str = strcat(tc(ib,1),{'.NP time trace.csv'});
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
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Summary
            if strcmpi(sumy,'yes')
                app.SLamp.Color = [1 0 0] ;
                Y=0;
                f3=figure;
                X = categorical({'Summary'});
                X = reordercats(X,{'Summary'});
                f3=barh(X,Y);
                title('Summary progress (%)');
                saveas(f3,'Summary AIO.pdf');
                
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
                    if sznpn(2)==1%tcsize(1)==1
                        xr=xr';
                    end
                    xlswrite(filed,round(xr,1),'NP number overall',B2);
 
                    Y=Y+(70/sznpn(1));
                    f3=barh(X,Y)
                    title('Summary progress (%)')
                    drawnow
                    saveas(f3,'Summary AIO.pdf')
                    
                    
                end
                

                tsumsize=size(tsum);
                
                for i=2:tsumsize(1)
                    xlswrite(filed,tc',tsum{i,1},'B1');
                    xlswrite(filed,tn(:,1),tsum{i,1},'A1');
                    xr = squeeze(sumdata(i-1,:,:));
                    if or(sznpn(2)==1,tcsize(1)==1)
                        xr=xr';
                    end
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
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Concurrency
            % there is always a portion that we are blind to for example TiFeZn might exist and be lower than "fac2" but it sub class does not (Ti, FeZn/ Fe, TiZn/ Zn, TiFe)
            % and so far the code is blind to that and blind portion could be as high as 15% of element data so please use as big file size as possible to minimized that or used smaller "fac1" fact 2 seems has no effect for blind portion

            if strcmpi(conc,'yes')
                app.CLamp.Color = [1 0 0] ;

                tx=tx';
                tax=el_sim(tx(:,1));
                
                tcsize=size(tc)
                Y=zeros([1,tcsize(1)]);
                f1=figure;
                X = categorical(tc(:,1));
                X = reordercats(X,tc(:,1));
                f1=barh(X,Y);
                title('hpCC Processing time (s)');
                saveas(f1,'hpCC Processing time.pdf');
                
                fac=1;
                fac2=2%nm(1,1);
                exn='.NP time trace.csv';%.npv.csv
                
                fac3=[];    %normally 1 or 2. fot cuncurency decition how many time an mix event should be larger than its concurent to not be consider as fake
                valu=0.49; %for grouping decition 0.49 for low sub group o.5 for higher subgroup
                base=3;    % base for coding of the data minimom of 3. the base 2 wont work properly
                chans=0;  % if a NPc compose of NP (A and B) what should be thier subtraction to place chans insted of that small number %please look at the code for more informaiton
                
                for ti=1:tcsize(1)
                    start_con=toc;
                    
                    Y(ti)=toc-start_con;
                    f1=barh(X,Y)
                    title('hpCC Processing time (s)')
                    drawnow
                    saveas(f1,'hpCC Processing time.pdf')

                    nnpv=[];
                    for fw=1:1 %for the number of rows in filename this loop will be repeated%
                        str = strcat(tc(ti,fw),{exn});
                        file=[str{:}]
                        [pv,tnpv] = xlsread(file);

                        nnpv=cat(1,nnpv,pv);
                    end

                    Y(ti)=toc-start_con;
                    f1 =barh(X,Y);
                    title('hpCC Processing time (s)')
                    saveas(f1,'hpCC Processing time.pdf')

                    NPdata=nnpv;
                    NPdata_con=nnpv;
                    str = strcat(tc(ti,1),{'.xlsx'});
                    file = [str{:}];
                    
                    sum_NPdata_con=sum(sum(NPdata_con,1),2);
                    if sum_NPdata_con>2
                        
                        % part 1 counting
                        [List_1, layer_data, unic_freq_data,nns]=unic_num(NPdata,fac,base); %make sure the line data are correct
                        %[List_1_E,last_write_pos_E]=Squeez_Write(tc,ti,List_1,1,file,base,tax);
                        [List_1_E,last_write_pos_E]=Squeez_Write(tc,ti,List_1,1,file,base,tax,'Before hpCC');
                        Y(ti)=toc-start_con;
                        f1=barh(X,Y);
                        title('hpCC Processing time (s)')
                        saveas(f1,'hpCC Processing time.pdf')
                        
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
                                    title('hpCC Processing time (s)')
                                    %saveas(f1,'Coun Processing time.pdf')
                                end
                            end
                            
                        end
                        
                        Y(ti)=toc-start_con;
                        f1=barh(X,Y)
                        title('hpCC Processing time (s)')
                        saveas(f1,'hpCC Processing time.pdf')
                        
                        % part 3 squeezing and writing
                        %[List_3,last_write_pos]=Squeez_Write(tc,ti,List_2,1,file,base,tax,'After hpCC'); %error in this line means you have a file with no concurent events
                        
                        Y(ti)=toc-start_con;
                        f1=barh(X,Y)
                        title('hpCC Processing time (s)')
                        saveas(f1,'hpCC Processing time.pdf')

                    end
                    tra=sum(NPdata_con,2);
                    tra=find(tra>0);
                    if isempty(tra)
                        tra=1;
                    end
                    NPdata_con=NPdata_con(tra,:);
                    
                    str = strcat(tc(ti,1),{'.hpCC.csv'});
                    %str = strcat(tc(ti,1),{'.csv'});
                    file=[str{:}]
                    tit=el_sim_two(tax);
                    sd = array2table(NPdata_con);
                    sd.Properties.VariableNames=tit;
                    writetable(sd,file,'Delimiter',',')

                    Y(ti)=toc-start_con;
                    f1=barh(X,Y)
                    title('hpCC Processing time (s)')
                    saveas(f1,'hpCC Processing time.pdf')
                end
                %tob=base2dec(tope,3);
                %tobt=num_nam(tob,3,tax);
                %xlswrite(filed,tobt','tope','B1');
                %xlswrite(filed,tob','tope','A2');
                app.CLamp.Color = [0 1 0] ;
                
                xlswrite(filed,{'Concurrency analysis time (s)'},'Read me AIO','A15');
                xlswrite(filed,tc(:,1),'Read me AIO','A16');
                xlswrite(filed,Y','Read me AIO','B16');
                
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% First Clustring
            
            
            if strcmpi(Clus_switch,'yes')
                app.HCLamp.Color = [1 0 0] ;
                
                % Find the classes of particle in the corected dataset for concurency 2020.09.17
                
                %clear
                %tic % time start
                
                %[filed,path] = uigetfile('../*.xlsx');
                %cd (path)
                
                [nd,tc] = xlsread(filed,'Filename');
                tc=tc(2:end,:);
                [nx,tx] = xlsread(filed,'Elements');
                [AE,At] = xlsread(filed,'Absolute sensitivity(CountsPng)');%
                [qp,qt] = xlsread(filed,'q_plasma(mlPs)');%
                [nm,tm]=xlsread(filed,'Read me Den');
                
                size_tx=size(tx);
                sab=[];
                for ihat=1:size_tx(1)
                    sab=cat(2,sab,{[tx{ihat,:}]});
                end
                tx=sab;
                
                tcsize=size(tc)
                Y=zeros([1,tcsize(1)]);
                f1=figure;
                X = categorical(tc(:,1));
                X = reordercats(X,tc(:,1));
                
                f1=barh(X,Y);
                title('Processing data (%)');
                saveas(f1,'Den Processing data.pdf');

                Ab_Ef=AE;
                q_plasma=qp(:,1);
                Time_M=qp(:,2);
                
                size_AE=size(AE);
                size_qp=size(qp);
                if and(size_AE(1)==size_qp(1),size_AE(1)==tcsize(1))
                    if and(size_AE(2)==size_tx(1), size_qp(2)==2)
                    else
                        error('More or less numbers of sensitivity or q-plasma entered as input');
                        
                    end
                else
                    error('More or less numbers of sensitivity or q-plasma entered as input');
                end
                
                %[ntope,ttope] = xlsread(filed,'tope');
                tx=tx';
                tax=el_sim(tx(:,1));
                %end
                
                
                cutoff1=nm(1,1);  %something for hierarcial classifcation
                PCF=nm(2,1);% min chance to be included to the class dosent matter M or T
                fx_max=nm(3,1); %max number of cluster in one sample. If it is more it will rise an error.
                cutoff2=nm(4,1);
                typf=tm{5,2}; % addition to file name
                
                COF=5; % Coefficnet of aggregation
                PCC=0.33; % percentage of element occurance in that class
                cycles=3; % median calculation repitision
                
                xlswrite(filed,[{'Cutoff1'},{'Occarance in cluster rate'},{'Max number of clusters'},{'Cutoff2'},{'File name additon text'},{'Date'}]','Read me Den','A1');
                xlswrite(filed,[cutoff1,PCF,fx_max,cutoff2,typf,{date}]','Read me Den','B1');
                
                %%%%%%%%%%%%%Class of NP
                class_store=[];
                name_class=[];
                class_number=[];
                class_number_std=[];
                class_number_raw=[];
                code_class=[];
                act_All=[];
                mean_NP_All=[];
                med_NP_All=[];
                sum_NP_one_All=[];
                sum_NP_one_std_All=[];
                std_NP_All=[];
                major_all=[];
                major_cla_all=[];
                major_cla=[];
                major_cla_std=[];
                raw_sum_NP_one_All=[];
                
                for ti=1:tcsize(1)
                    
                    
                    Y(ti)=10
                    f1=barh(X,Y)
                    title('Processing data (%)')
                    drawnow
                    saveas(f1,'Den Processing data.pdf')

                    nnpv=[];
                    for f=1:1 %for the first colum in filename this loop will be repeated%
                        str = strcat(tc(ti,f),typf);
                        file=[str{:}]
                        [pv,tnpv] = xlsread(file);
                        nnpv=cat(1,nnpv,pv);
                    end
                    
                    Y(ti)=50;
                    f1=barh(X,Y)
                    title('Processing data (%)')
                    saveas(f1,'Den Processing data.pdf')
                    
                    
                    NPdata_con=nnpv;
                    NPdata_con=NPdata_con./Ab_Ef(ti,:);% from Count to mass in 'ng'%%%% error cause wrong number of input in sheet "Absolute sensitivity(CountsPng)"
                    str = strcat(tc(ti,1),{'.Classes.xlsx'});
                    filee=[str{:}]
                    
                    hoof=NPdata_con;
                    hoof(hoof>0)=1;
                    size_hoof=size(hoof);
                    sum_hoof=sum(hoof,1);
                    general_binary_Chance=sum_hoof./size_hoof(1);
                    sg=sum(hoof,2);
                    
                    ind_2=find(sg>1);
                    good_NP=NPdata_con(ind_2,:);
                    
                    sizg=size(good_NP)
                    
                    ind_1=find(sg==1);
                    good_NP_1=NPdata_con(ind_1,:);
                    sizg_1=size(good_NP_1);
                    if ~isempty(good_NP_1)
                        xlswrite(filee,good_NP_1,'Single element','A2');
                        xlswrite(filee,tax','Single element','A1');
                    end
                    
                    if sizg(1)>1
                        
                        
                        [class_number_min,class_store_min,name_class_min,act_min,max_all,cla_all,cla_std_all,cal_max_all]=data_classy_big(NPdata_con,tax,filee,cutoff1,fx_max,COF,PCC,PCF,cycles);
                        class_store=cat(1,class_store,class_store_min);
                        name_class=cat(1,name_class,name_class_min);
                        act_All=cat(1,act_All,act_min);
                        major_all=cat(1,major_all,max_all);
                        major_cla_all=cat(1,major_cla_all,cal_max_all);
                        major_cla=cat(1,major_cla,cla_all);
                        major_cla_std=cat(1,major_cla_std,cla_std_all);
                        
                        
                        
                        class_number_con=class_number_min/q_plasma(ti)/Time_M(ti);% from Number to concentration in particle/ml
                        class_number_con_std=class_number_min.^(1/2)/q_plasma(ti)/Time_M(ti);
                        class_number=cat(1,class_number,class_number_con);
                        class_number = round(class_number);
                        
                        class_number_std=cat(1,class_number_std,class_number_con_std);
                        class_number_std = round(class_number_std);
                        
                        class_number_raw=cat(1,class_number_raw,class_number_min);
                        nee=length(class_number_min);
                        code=ones(nee,1)*ti;
                        code_class=cat(1,code_class,code);
                        
                        [mean_NP,med_NP,con_NP_one,con_NP_one_std,std_NP,raw_sum_NP_one]=Single_element_NP(NPdata_con,q_plasma(ti),Time_M(ti));
                        mean_NP_All=cat(1,mean_NP_All,mean_NP);
                        med_NP_All=cat(1,med_NP_All,med_NP);
                        sum_NP_one_All=cat(1,sum_NP_one_All,con_NP_one);
                        sum_NP_one_std_All=cat(1,sum_NP_one_std_All,con_NP_one_std);
                        if sizg_1(1)>1
                            std_NP_All=cat(1,std_NP_All,std_NP); %Error in this line due to very low Single elment nano particles
                        else
                            std_NP_All=cat(1,std_NP_All,zeros(1,sizg(2)));
                        end
                        raw_sum_NP_one_All=cat(1,raw_sum_NP_one_All,raw_sum_NP_one);
                        
                        Y(ti)=100;
                        f1=barh(X,Y);
                        title('Processing data (%)');
                        saveas(f1,'Den Processing data.pdf');
                        

                    else
                        [mean_NP,med_NP,con_NP_one,con_NP_one_std,std_NP,raw_sum_NP_one]=Single_element_NP(NPdata_con,q_plasma(ti),Time_M(ti));
                        mean_NP_All=cat(1,mean_NP_All,mean_NP);
                        med_NP_All=cat(1,med_NP_All,med_NP);
                        sum_NP_one_All=cat(1,sum_NP_one_All,con_NP_one);
                        sum_NP_one_std_All=cat(1,sum_NP_one_std_All,con_NP_one_std);
                        if sizg_1(1)>1
                            std_NP_All=cat(1,std_NP_All,std_NP); %Error in this line due to very low Single elment nano particles
                        else
                            std_NP_All=cat(1,std_NP_All,zeros(1,sizg(2)));
                        end
                        
                        raw_sum_NP_one_All=cat(1,raw_sum_NP_one_All,raw_sum_NP_one);
                        
                        Y(ti)=100;
                        f1=barh(X,Y);
                        title('Processing data (%)');
                        saveas(f1,'Den Processing data.pdf');
                        
                        
                    end
                end
                
                Y=zeros(1);
                f2=figure;
                X = categorical({'writing data(%)'});
                X = reordercats(X,{'writing data(%)'});
                
                Y=0;
                f2=barh(X,Y);
                title('writing data (%)');
                drawnow;
                saveas(f2,'Den writing data.pdf');
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Second Clustring: Class of classes
                
                if ~isempty (class_store)
                    x=class_store(:,:,3); % chance
                    mean_class_con=class_store(:,:,7).*class_number./1000; %ug/ml obtional .*act_All
                    z=class_store(:,:,4);
                    z(isnan(z))=0;
                    z_std=class_store(:,:,6);
                    %tree = linkage(z,'average','correlation');
                    %class_of_class = cluster(tree,'Cutoff',0.5,'criterion','distance');
                    %max_c= max(class_of_class)
                    
                    % One way to measure how well the cluster tree generated by the linkage function reflects your data is to compare the cophenetic distances with the original distance
                    %c = cophenet(tree,pdist(z,'correlation')) % Verify Dissimilarity
                    
                    %One way to determine the natural cluster divisions in a data set is to compare the height of each link in a cluster tree with the heights of neighboring links below it in the tree.
                    %I = inconsistent(tree);% Verify Consistency
                    %MeanI=mean(I(:,4))
                    %W_MeanI=sum(I(:,3).*I(:,4))/sum(I(:,3))
                    
                    %dendrogram(tree,0,'Labels',name_class)
                    sizex=size(x);
                    if sizex(1)>1
                        %%%%% linkage
                        tree = linkage(z,'average','correlation');
                        class_of_class = cluster(tree,'Cutoff',cutoff2,'criterion','distance');
                        [H,T,outperm]=dendrogram(tree,0,'Labels',name_class,'Orientation','left','ColorThreshold','default','ColorThreshold',cutoff2);
                        %c = cophenet(tree,pdist(z,'correlation')) % Verify Dissimilarity
                        %I = inconsistent(tree);% Verify Consistency
                        set(H,'LineWidth',1);
                        x0=10;
                        y0=10;
                        width=300;
                        height=3000;
                        set(gcf,'position',[x0,y0,width,height])
                        %set(gcf,'DefaultTextFontSize',18)
                        saveas(gcf,'Dendrogram.pdf')
                        saveas(gcf,'Dendrogram.fig')
                        openfig('Dendrogram.fig','visible')
                        
                        x0=40;
                        y0=40;
                        width=300;
                        height=300;
                        %set(gcf,'position',[x0,y0,width,height])
                        
                    else
                        class_of_class=1;
                        outperm=1;
                    end
                    
                    
                    
                    
                    
                    
                    %Cluster writer
                    
                    
                    Element_chance=x;
                    
                    sample_name=name_class;
                    Element=tax';
                    Cluster=class_of_class;
                    actual=class_number_raw;
                    con=class_number;
                    NP_row=code_class;
                    size_data=size(class_number);
                    
                    NP_row_size=max(NP_row)
                    
                    Cluster_size=max(Cluster)
                    
                    
                    %name=sample_name(1:NP_row_size);
                    size_Element=size(Element);
                    Cluster_Element_chance=zeros([Cluster_size,size_Element(2)]);
                    Cluster_con=zeros([Cluster_size,NP_row_size]);
                    
                    
                    for i=1:size_data(1)
                        %name(NP_row(i))=sample_name(i);
                        Cluster_con(Cluster(i),NP_row(i))=Cluster_con(Cluster(i),NP_row(i))+con(i);
                        Cluster_Element_chance(Cluster(i),:)=Cluster_Element_chance(Cluster(i),:)+Element_chance(i,:);
                    end
                    Cluster_name={};
                    for j=1:Cluster_size
                        a=[];
                        [~,max_chance]=max(Cluster_Element_chance(j,:));
                        a= cat(2,a,Element{max_chance});
                        a=strcat(a,'/');
                        Cluster_Element_chance(j,max_chance)=0;
                        [~,max_chance]=max(Cluster_Element_chance(j,:));
                        a= cat(2,a,Element{max_chance});
                        a = erase(a,'+');
                        a={a};
                        Cluster_name=cat(1,Cluster_name,a);
                    end
                    

                    
                    size_name_class=size(name_class);
                    Cluster_row=(1:size_name_class(1))';
                    
                    sheetname='Clusters particle con.';
                    xlswrite(filed,{'Concentration (particles/ml)'},sheetname,'A1');
                    xlswrite(filed,tc(:,1),sheetname,'A2');
                    xlswrite(filed,Cluster_name',sheetname,'B1');
                    xlswrite(filed,Cluster_con',sheetname,'B2');
                    
                    sheetname='Clusters mass proxy';
                    xlswrite(filed,{'Cluster row','Sample row','Inter-sample cluster number','Actual number of events','Concentration (particles/ml)','median mass (ng)'},sheetname,'A1');
                    xlswrite(filed,Cluster_row,sheetname,'A2');
                    xlswrite(filed,code_class,sheetname,'B2');
                    xlswrite(filed,class_of_class,sheetname,'C2');
                    xlswrite(filed,class_number_raw,sheetname,'D2');
                    xlswrite(filed,class_number,sheetname,'E2');
                    xlswrite(filed,name_class,sheetname,'F2');
                    xlswrite(filed,tax',sheetname,'G1');
                    xlswrite(filed,z.*major_all,sheetname,'G2');
                    
                    sheetname='Clusters mass proxy_tree sorted';
                    xlswrite(filed,{'Cluster row','Sample row','Inter-sample cluster number','Actual number of events','Concentration (particles/ml)','median mass (ng)'},sheetname,'A1');
                    xlswrite(filed,Cluster_row(outperm,:),sheetname,'A2');
                    xlswrite(filed,code_class(outperm,:),sheetname,'B2');
                    xlswrite(filed,class_of_class(outperm,:),sheetname,'C2');
                    xlswrite(filed,class_number_raw(outperm,:),sheetname,'D2');
                    xlswrite(filed,class_number(outperm,:),sheetname,'E2');
                    xlswrite(filed,name_class(outperm,:),sheetname,'F2');
                    xlswrite(filed,tax',sheetname,'G1');
                    xlswrite(filed,z(outperm,:).*major_all(outperm,:),sheetname,'G2');
                    
                    sheetname='Clusters mass proxy 10th occ.';
                    xlswrite(filed,{'Cluster row'},sheetname,'A1');
                    xlswrite(filed,Cluster_row,sheetname,'A2');
                    xlswrite(filed,name_class,sheetname,'B2');
                    xlswrite(filed,tax',sheetname,'C1');
                    xlswrite(filed,major_cla.*major_cla_all,sheetname,'C2');
                    
                    Y=10;
                    f2=barh(X,Y);
                    saveas(f2,'Den writing data.pdf');
                    
                    sheetname='Clusters occ. rate of elements';
                    xlswrite(filed,{'Cluster row','Occurrence in cluster rate of all elements(ratio)'},sheetname,'A1');
                    xlswrite(filed,Cluster_row,sheetname,'A2');
                    xlswrite(filed,name_class,sheetname,'B2');
                    xlswrite(filed,tax',sheetname,'C1');
                    xlswrite(filed,x,sheetname,'C2');
                    
                    sheetname='Clusters mass con. of elements';
                    xlswrite(filed,{'Cluster row','Total mass concentration of all elements(ug/ml)'},sheetname,'A1');
                    xlswrite(filed,Cluster_row,sheetname,'A2');
                    xlswrite(filed,name_class,sheetname,'B2');
                    xlswrite(filed,tax',sheetname,'C1');
                    xlswrite(filed,mean_class_con,sheetname,'C2');
                    
                    
                    
                    Y=50;
                    f2=barh(X,Y);
                    saveas(f2,'Den writing data.pdf');

                    
                    dat=z';
                    std=z_std';
                    dat=dat(:,outperm);
                    std=std(:,outperm);
                    tdata=name_class(outperm,:);
                    sizd=size(dat);
                    comb=nan(sizd(1),2*sizd(2));
                    %name=nan(1,2*sizd(2));
                    name={};
                    for i=1:sizd(2)
                        comb(:,2*i-1)=dat(:,i);
                        comb(:,2*i)=std(:,i);
                        name=cat(1,name,tdata(i));
                        name=cat(1,name,{''});
                    end
                    
                    comb(comb==0)=nan;
                    xlswrite(filed,{'Data'},'Sort proxy Norm and error','A1');
                    xlswrite(filed,comb','Sort proxy Norm and error','B2');
                    xlswrite(filed,name,'Sort proxy Norm and error','A2');
                    xlswrite(filed,tax','Sort proxy Norm and error','B1');
                    
                    dat=major_cla';
                    std=major_cla_std';
                    
                    dat=dat(:,outperm);
                    std=std(:,outperm);
                    tdata=name_class(outperm,:);
                    sizd=size(dat);
                    comb=nan(sizd(1),2*sizd(2));
                    %name=nan(1,2*sizd(2));
                    name={};
                    for i=1:sizd(2)
                        comb(:,2*i-1)=dat(:,i);
                        comb(:,2*i)=std(:,i);
                        name=cat(1,name,tdata(i));
                        name=cat(1,name,{''});
                    end
                    comb(comb==0)=nan;
                    xlswrite(filed,{'Data'},'Sort 10th proxy Norm and error','A1');
                    xlswrite(filed,comb','Sort 10th proxy Norm and error','B2');
                    xlswrite(filed,name,'Sort 10th proxy Norm and error','A2');
                    xlswrite(filed,tax','Sort 10th proxy Norm and error','B1');
                    
                    Y=80;
                    f2=barh(X,Y)
                    saveas(f2,'Den writing data.pdf')
                    
                end
                
                
                [A1,A2,B1,B2]=exgen(tcsize(1),1);
                xlswrite(filed,{'Median mass (ng)'},'single element',A1);
                xlswrite(filed,tc(:,1),'single element',A2);
                xlswrite(filed,tax','single element',B1);
                xlswrite(filed,med_NP_All,'single element',B2);
                
                [A1,A2,B1,B2]=exgen(tcsize(1),2);
                xlswrite(filed,{'mean mass (ng)'},'single element',A1);
                xlswrite(filed,tc(:,1),'single element',A2);
                xlswrite(filed,tax','single element',B1);
                xlswrite(filed,mean_NP_All,'single element',B2);
                
                [A1,A2,B1,B2]=exgen(tcsize(1),3);
                xlswrite(filed,{'Con. (particles/ml)'},'single element',A1);
                xlswrite(filed,tc(:,1),'single element',A2);
                xlswrite(filed,tax','single element',B1);
                xlswrite(filed,sum_NP_one_All,'single element',B2);
                
                [A1,A2,B1,B2]=exgen(tcsize(1),4);
                xlswrite(filed,{'std. Con. (particles/ml)'},'single element',A1);
                xlswrite(filed,tc(:,1),'single element',A2);
                xlswrite(filed,tax','single element',B1);
                xlswrite(filed,sum_NP_one_std_All,'single element',B2);
                
                [A1,A2,B1,B2]=exgen(tcsize(1),5);
                xlswrite(filed,{'mass Con.  (ug/ml)'},'single element',A1);
                xlswrite(filed,tc(:,1),'single element',A2);
                xlswrite(filed,tax','single element',B1);
                xlswrite(filed,(sum_NP_one_All.*mean_NP_All)/1000,'single element',B2);
                
                [A1,A2,B1,B2]=exgen(tcsize(1),6);
                xlswrite(filed,{'std. mass Con.  (ug/ml)'},'single element',A1);
                xlswrite(filed,tc(:,1),'single element',A2);
                xlswrite(filed,tax','single element',B1);
                xlswrite(filed,(sum_NP_one_std_All.*mean_NP_All)/1000,'single element',B2);
                
                [A1,A2,B1,B2]=exgen(tcsize(1),7);
                xlswrite(filed,{'std. Median mass (ng)'},'single element',A1);
                xlswrite(filed,tc(:,1),'single element',A2);
                xlswrite(filed,tax','single element',B1);
                xlswrite(filed,std_NP_All,'single element',B2);
                
                [A1,A2,B1,B2]=exgen(tcsize(1),8);
                xlswrite(filed,{'raw number of event detected'},'single element',A1);
                xlswrite(filed,tc(:,1),'single element',A2);
                xlswrite(filed,tax','single element',B1);
                xlswrite(filed,raw_sum_NP_one_All,'single element',B2);
                
                Y=100;
                f2=barh(X,Y)
                saveas(f2,'Den writing data.pdf')
                
                %set(gcf,'position',[x3,y3,width3,height3])
                
                app.HCLamp.Color = [0 1 0] ;
            end
            
            
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%End process lines
            
            xlswrite(filed,{app.NanoFinder559Label.Text},'Read me AIO','B15');
            xlswrite(filed,{'total time (s)'},'Read me AIO','A14');
            xlswrite(filed,toc,'Read me AIO','B14');
            
            Yy=100;
            f4=figure;
            X = categorical({'Analysis'});
            X = reordercats(X,{'Analysis'});
            f4=barh(X,Yy);
            title('All analysis (%)');
            saveas(f4,'All analysis.pdf');
            
            app.Lamp.Color = [0 1 0] ;
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%End of code%%%%%%%%

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Start of Functions
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
                xlswrite(filed,tc,'Filename','B2');
            end
            
            function[tc]=read_file(filed)
                [~,tc]=xlsread(filed,'Filename');

            end
            
            function [sample,st,ed]=Datasize(num,st,ed)
                b=size (num);
                if and(0==st,0==ed)
                    sample=num;
                    st=1;
                    ed=b(1);
                elseif 0==st
                    sample=num(1:ed,:);
                    st=1;
                elseif 0==ed
                    sample=num(st:end,:);
                    ed=b(1);
                elseif and (st<ed,b(1)>=(st-ed))
                    sample=num(st:ed,:);
                    
                else
                    error(' Not a suatable file size. try to change start and end data row')
                end
                
            end
            

            function []=NEWwritedata(sample,txt,strn)
                
                stre = strcat(strn,{'.raw.csv'});
                files=[stre{:}];

                sdw = array2table(sample);
                sdw.Properties.VariableNames=txt;
                writetable(sdw,files,'Delimiter',',')
            end
            
            function [num,raw_WF,raw_name]=usable_data(list,table,listnew,WF)
                sizelist=size(list);
                sizetlistnew=size(listnew);
                sizetable=size(table);
                k=0;
                num=zeros(sizetable(1),sizetlistnew(1));
                raw_WF=[];
                raw_name=[];
                for id=1:sizetlistnew(1)

                    minilist=listnew(id,:);
                    indexE=find(~cellfun(@isempty,minilist));
                    sizeminilist=size(indexE);
                    for y=1:sizeminilist(2)
                        for jd=1:sizelist(1)
                            if isequal(minilist(y),list(jd))
                                %size(WF)
                                num(:,id)=num(:,id)+table(:,jd)*WF;
                                raw_WF=cat(2,raw_WF,table(:,jd)*WF);
                                raw_name=cat(2,raw_name,minilist(y));
                                break
                            elseif jd==sizelist(1)
                                el=string(minilist(y));
                                msg=strcat(el,' didnt exist in mass table')
                                error('Break');%%%%%%%%%rise an error

                            end
                        end
                    end
                end
            end
            
            
            function [sample,diss,strn,WF,st,ed]= Readtof(typ,strn,listnew,WF,st,ed)
                if strcmpi(typ,'csv')
                    strn = strcat(strn,{'.csv'});
                    [table,list] = xlsread([strn{:}]);

                    list=list'; % Because H5 file are this way so we need to keep it constant
                    strn = erase(strn,".csv");
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
                    WF = h5readatt(h5_filenamem,'/','NbrWaveforms'); %%%Error is due to wrong integration_window input
                    WF=double(WF);
                end
                
                [num,raw_WF,raw_name]=usable_data(list,table,listnew,WF);
                [sample,st,ed]=Datasize(num,st,ed);
                
                NEWwritedata(raw_WF,raw_name,strn);
                
                sample(sample<0)=0; % added for S-TOF issue
   
                diss=mean(sample,1);

                strn = strcat(strn,{'.csv'});

                
            end
            
            function [peakList,data]=hd5fileread(h5_filename)

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

            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Split event
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

            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Top finder
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
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%correlation
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

                
                
                xlswrite(file,txt,'Cor cof','B2');
                xlswrite(file,txt','Cor cof','A3');
                xlswrite(file,Cor_matrix,'Cor cof','B3');

                xlswrite(file,txt,'NP Number','B2');
                xlswrite(file,txt','NP Number','A3');
                xlswrite(file,NpN_matrix,'NP Number','B3');

                
            end
            
            
            function [A1,A2,B1,B2]=exgen(Siz,num)
                pos=(Siz+1)*(num-1);
                A1= strcat('A',num2str(pos+1));
                A2= strcat('A',num2str(pos+2));
                B1= strcat('B',num2str(pos+1));
                B2= strcat('B',num2str(pos+2));
            end
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Functions concurency
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
                        dc(dc>=fac2)=1; %'fac' is a variable defined by user and it will keep only nanoparticle type which happened equal or more tnan 'fac' times.
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
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Rest
            
            
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
                                subtract=round((jk+a(xa,2))*(jk+b(y,2))/sizedata,0);
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
                match = ['[',']','+',':','*',"'",'0','1','2','3','4','5','6','7','8','9','+'];
                %match = ["[",']'];
                table_name=[];
                for i=1:lentab
                    x=tab{i};
                    [ii,jj,kk]=unique(x);
                    ii=erase(ii,match);
                    if ~isnan(find(strcmp(table_name,ii)))
                        match2=['[',']','+',':','*',"'"];
                        ii=x;
                        ii=erase(ii,match2);
                    end
                    table_name=cat(1,table_name,{ii});
                end
                
            end
            
            function [table_name]=el_sim_two(tab)
                lentab=length(tab);
                match = ['[',']','+',':','*',"'",'0','1','2','3','4','5','6','7','8','9','+'];
                %match = ["[",']','+'];
                table_name=[];
                for i=1:lentab
                    x=tab{i};
                    [ii,jj,kk]=unique(x);
                    ii=erase(ii,match);
                    if ~isnan(find(strcmp(table_name,ii)))
                        ii=x;
                        match2=["[",']','+',':','*',"'"];
                        ii=erase(ii,match2);
                    end
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

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Cluster
    
            function [class_number,class_store,name_class,act_all,max_all,cla_all,cla_std_all,cal_max_all]=data_classy_big(NPdata_con,tax,file,cutof,fx_max,COF,PCC,PCF,cycles)
                hoof=NPdata_con;
                hoof(hoof>0)=1;
                size_hoof=size(hoof);
                sum_hoof=sum(hoof,1);
                general_binary_Chance=sum_hoof./size_hoof(1);
                sg=sum(hoof,2);
                
                ind_2=find(sg>1);
                good_NP=NPdata_con(ind_2,:);

                sizg=size(good_NP)
                
                if sizg(1)>1

                    
                    
                    Z = linkage(good_NP,'average','correlation');%%%%%% Binary_
                    c = cluster(Z,'Cutoff',cutof,'criterion','distance');

                    
                    fx=max(c);
                    histogram(c)
                    if fx<fx_max
                        class_store=[];
                        name_class=[];
                        class_number=[];
                        act_all=[];
                        act_all_gen=[];
                        max_all=[];
                        cal_max_all=[];
                        cla_all=[];
                        cla_std_all=[];
                        %Lazy part of the code
                        sdds=[];
                        for i=1:fx
                            inde=find(c==i);
                            df=good_NP(inde,:);
                            sheetname=strcat('Class',num2str(i));
                            [~,~,~,sumee]=correlation_coefs_modified_big(df,file,tax',[sheetname,' sum']);
                            sdds=cat(1,sdds,sumee);
                        end
                        for ifa=1:fx
                            inde=find(c==ifa);
                            df=good_NP(inde,:);
                            sheetname=strcat('Class',num2str(ifa));
                            [number_NP,nmedian,sumNP,sumbinary_Chance]=correlation_coefs_modified_big(df,file,tax',[sheetname,' sum']);
                            
                            dfss=size(df);
                            [className,act,subclass_name]=className_function_3(file,tax,sumbinary_Chance,general_binary_Chance,COF,PCC,PCF,sdds,sumNP,dfss(1));
                            [~,act_gen,~]=className_function_3(file,tax,sumbinary_Chance,general_binary_Chance,COF,PCC,PCF/10,sdds,sumNP,dfss(1));
                            
                            [rat_f_med,org_f_med,std_rat_f_med,med_max_med,mea_f]=median_finder(df,sumbinary_Chance,act,cycles);
                            [rat_f_med_gen,~,std_rat_f_med_gen,med_max_med_gen,~]=median_finder(df,sumbinary_Chance,act_gen,cycles);

                            cla=rat_f_med_gen;
                            cla_std=std_rat_f_med_gen;
                            
                            
                            
                            name_class=cat(1,name_class,className);
                            act_all=cat(1,act_all,act);
                            act_all_gen=cat(1,act_all_gen,act_gen);
                            class_number=cat(1,class_number,number_NP);
                            
                            df(df==0)=nan;
                            std_df=nanstd(df,1);
                            
                            
                            %   important
                            sheetname=strcat(num2str(ifa),subclass_name);
                            
                            xlswrite(file,df,sheetname,'A2'); %%
                            xlswrite(file,tax',sheetname,'A1');%%

                            
                            max_all=cat(1,max_all,med_max_med);
                            cal_max_all=cat(1,cal_max_all,med_max_med_gen);
                            cla_all=cat(1,cla_all,cla);
                            cla_std_all=cat(1,cla_std_all,cla_std);
                            
                            classD=nmedian;
                            classD=cat(3,classD,sumNP);
                            classD=cat(3,classD,sumbinary_Chance);
                            classD=cat(3,classD,rat_f_med);
                            classD=cat(3,classD,org_f_med);
                            classD=cat(3,classD,std_rat_f_med);
                            classD=cat(3,classD,mea_f);
                            
                            len_NPs=length(sumNP);
                            std_df(end+1:len_NPs)=NaN;
                            classD=cat(3,classD,std_df);
                            class_store=cat(1,class_store,classD);
                            
                        end

                    else
                        error='you have more than "fx_max number" of Cluster so it didnt store them in'
                    end
                end
            end
            
            function [number_NP,nmedian,sumNP,sumbinary_Chance]=correlation_coefs_modified_big (NPD,file,txt,Class_name)
                %adopted from AOI V7.1 on 2020.02.28 and changed
                Binary_detection=NPD;
                Binary_detection(Binary_detection>0)=1;
                
                
                S=size(Binary_detection);
                sumbinary=sum(Binary_detection,1);
                sumbinary_Chance=sumbinary/S(1);
                number_NP=S(1);
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
                sumbinary_Chance=round(sumbinary_Chance,4);
                
                Bomb_data=NpN_matrix;
                Bomb_data=cat(2,Bomb_data,nan(S(2),1));
                if S(1)>1
                    Bomb_data=cat(2,Bomb_data,Cor_matrix);
                end

            end

            
            function [className,act,subclass_name]=className_function_3(file,tax,sumbinary_Chance,general_binary_Chance,COF,PCC,PCF,sdds,sumNP,sdf)
                %at two condition an element will be included in the class
                re_l=length(tax);
                for i=1:re_l
                    c=tax{i};
                    newChr = strrep(c,'+','-');
                    tax(i)={newChr};
                end

                
                CH=size(sumbinary_Chance);
                
                
                %3
                act=zeros(CH);
                for j=1:CH(2)
                    %if and(sumbinary_Chance(j)>=medxd(j),sumbinary_Chance(j)>PCF)
                    if sumbinary_Chance(j)>PCF
                        %  if sumbinary_Chance(j)>PCF
                        act(j)=1;
                        %   end
                    end
                end
                
                [out,idx] = sort(sumbinary_Chance.*act,'descend');
                out(out>0)=1;
                sumout=sum(out);
                
                %ind_max=find(sumbinary_Chance==max(sumbinary_Chance));
                className={join([file(1:end-13)])};
                if sumout>=3
                    className={join([className{:},tax{idx(1:3)}])};
                    subclass_name=join([tax{idx(1:3)}]);
                else
                    className={join([className{:},tax{idx(1:sumout)}])};
                    subclass_name=join([tax{idx(1:sumout)}]);
                end
                
            end
            
            function [mean_NP,med_NP,con_NP_one,con_NP_one_std,std_NP,sum_NP_one]=Single_element_NP(NPdata_con,q_plasma,Time_M)
                snp=NPdata_con;
                snp(snp>0)=1;
                
                sum_NP=sum(snp,2);
                ind_one=find(sum_NP==1);
                snp=snp(ind_one,:);
                mass_snp=NPdata_con(ind_one,:);
                sum_NP_one=sum(snp,1);
                
                mean_NP=sum(mass_snp,1)./sum_NP_one;
                
                con_NP_one=sum_NP_one/q_plasma/Time_M;
                con_NP_one_std=sum_NP_one.^(1/2)/q_plasma/Time_M;
                
                mass_snp(mass_snp==0)=NaN;
                med_NP=nanmedian(mass_snp,1);
                std_NP=nanstd(mass_snp,1);
            end
            
            function [rat_f_med,org_f_med,std_rat_f_med,med_max_med,mea_f]=median_finder(df,chance,act,cycles)
                size_df=size(df);
                rat_final=nan([cycles,size_df(2)]);
                org_final=nan([cycles,size_df(2)]);
                std_final=nan([cycles,size_df(2)]);
                mea_final=nan([cycles,size_df(2)]);
                
                bi_act=act;
                bi_act(bi_act>0)=1;
                
                indx_max=find(chance==max(chance));
                indx_max=indx_max(1);
                
                
                indx=find(bi_act>0);
                fingers=length(indx);
                
                mea_f=mean(df,1);
                df(df==0)=nan;
                
                for i=1:fingers
                    [rat,org,std]=elm_med_two(cycles,df,indx(i),indx_max);
                    if indx_max==indx(i)
                        med_max=org;
                    end
                    rat_final(:,indx(i))=rat;
                    org_final(:,indx(i))=org;
                    std_final(:,indx(i))=std;
                end
                std_rat_f_med=nanmedian(std_final,1);
                rat_f_med=nanmedian(rat_final,1);
                org_f_med=nanmedian(org_final,1);
                med_max_med=nanmedian(med_max,1); %error in this line related to the fact that you change one of the classes in a way that there is no nanoparitlce in it any more
                %mea_f=nanmean(mea_final,1);
            end
            
            function [rat,org,std]=elm_med_two(cycles,df,indx_finger,indx_max)
                rat=[];
                org=[];
                df_finger=df(:,indx_finger);
                df_max=df(:,indx_max);
                df_rat=df_finger./df_max;
                rat=nanmedian(df_rat,1);
                org=nanmedian(df_max,1);
                std=nanstd(df_rat,1);
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SIS_Hist%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            function []=SIS_Line_exp(filed)
                % 2021.03.07 SIS_HIS %
                % Kamyar Mehrabi % kamyarm@ethz.ch
                % ETH Zurich %
                
                %tic % time start
                [SIS,His]=xlsread(filed,'SIS Hist');
                [Line,tex_Line]=xlsread(filed,'Line');
                Line=sort(Line,1,'descend');
                
                SIS_h=SIS(:,1:2);
                SIS_value = sum(SIS_h(:,1).*SIS_h(:,2),1) / sum(SIS_h(:,2));
                
                [ex_SIS_Hist]=Full_SIS_Hist(SIS_h);
                
                Message='Single ion signal processing'
                Nmp=round(1/min(Line(:,1))*100);
                %Nmp=10000000
                %lmd2=0.5;
                
                %%%generating lmd Histogram
                
                st_lmd2=0.34;
                ed_lmd2=5;
                sp_lmd2=20;
                [lmd2]=lmd_gen(st_lmd2,sp_lmd2,ed_lmd2);
                lmd=lmd2.*lmd2;

                Gen_lmd_Hist=[];
                
                size_lmd=size(lmd);
                for iup=1: size_lmd(2)
                    Pos_serie=Give_Pos(Nmp,lmd(1,iup));% get nummber of bin and lmda and give Pos serie
                    sum(Pos_serie);
                    [lmd_Hist]=Monto(Pos_serie,ex_SIS_Hist,SIS_value);
                    
                    Gen_lmd_Hist=cat(2,Gen_lmd_Hist,lmd_Hist);
                end
                %%%Calculating Lc experession for different alpha
                
                %lmd2=sqrt(lmd);
                alpha=Line(:,1);
                [Lc_line]=Lc_Line_ep(Nmp,alpha,lmd2,Gen_lmd_Hist,'L_c expression');
                
                xlswrite(filed,[{'Alpha(rate)'},{'Slope'},{'Intercept'}],'Line','A1');
                xlswrite(filed,Lc_line,'Line','B2');
                xlswrite(filed,alpha,'Line','A2');
                
                alpha_2=sqrt(Line(:,1));
                [Lc_line_2]=Lc_Line_ep(Nmp,alpha_2,lmd2,Gen_lmd_Hist,'Split L_c expression');
                xlswrite(filed,[{'Alpha^0.5(rate)'},{'Slope'},{'Intercept'}],'Line','D1');
                xlswrite(filed,Lc_line_2,'Line','E2');
                xlswrite(filed,alpha_2,'Line','D2');
            end
            
            
            function [Pos_serie]=Give_Pos(Nmp,lmd)
                Nmp_sub=Nmp;
                ops=-1;
                Pos_serie=[];
                
                while Nmp_sub > 1
                    ops=ops+1;
                    P_ops=((lmd^(ops))*exp(0-lmd))/factorial(ops);
                    stpe=round(Nmp*P_ops);
                    Nmp_sub=Nmp_sub-stpe;
                    if and (stpe==0, ops>lmd)
                        stpe=stpe+Nmp_sub;% observation shows some time it doesent becume zero
                        Nmp_sub=0;
                    end
                    Pos_serie=cat(1,Pos_serie,stpe);
                    
                end
                sum_Pos_serie = sum(Pos_serie);
                if sum_Pos_serie~=Nmp
                    if Nmp_sub==1 %% this two if are here to make sure it give list as the same lentgh as Nmp
                        Pos_serie=cat(1,Pos_serie,1);
                    elseif sum_Pos_serie>Nmp
                        Pos_serie(end)=Pos_serie(end)-sum_Pos_serie+Nmp;
                    end
                end
                
            end

            function [ex_SIS_Hist]=Full_SIS_Hist(SIS_Hist)
                %SIS_Hist=SIS(:,1:2)
                
                size_SIS_Hist=size(SIS_Hist);
                
                ex_SIS_Hist=[];
                for iwe=1:size_SIS_Hist(1)
                    for jwe=1:SIS_Hist(iwe,2)
                        ex_SIS_Hist =cat(1,ex_SIS_Hist,SIS_Hist(iwe,1));
                    end
                end
                ex_SIS_Hist = ex_SIS_Hist(randperm(length(ex_SIS_Hist)));
            end
            

            function [lmd_Hist]=Monto(Pos_serie,ex_SIS_Hist,SIS_value)
                size_Pos_serie=size(Pos_serie);
                lmd_Hist=[];
                for iya=1:size_Pos_serie(1)
                    if Pos_serie(iya)>0
                        if iya==1
                            y=zeros(Pos_serie(1),1);
                            lmd_Hist=cat(1,lmd_Hist,y);
                        else

                            y =datasample(ex_SIS_Hist, (Pos_serie(iya)*(iya-1)) );%
                            y=reshape(y ,[Pos_serie(iya),(iya-1)]);
                            y=sum(y,2);
                            lmd_Hist=cat(1,lmd_Hist,y);
                            %end
                        end
                    end
                end
                
                lmd_Hist=lmd_Hist/SIS_value;
                lmd_Hist=sort(lmd_Hist,1,'descend');
                
                %histogram(lmd_Hist)
            end
            
            function [lmd]=lmd_gen(st_lmd2,sp_lmd2,ed_lmd2)
                sp_lmd2 = (ed_lmd2-st_lmd2)/sp_lmd2;
                lmd= st_lmd2:sp_lmd2:ed_lmd2;
            end
            
            
            function [Lc_line]=Lc_Line_ep(Nmp,alpha,lmd2,Gen_lmd_Hist,fign)
                size_lmd=size(lmd2);
                size_alpha=size(alpha);
                Lc_cont=zeros([size_lmd(2),size_alpha(1)]);
                %alpha=Line(:,1);
                Lc_line=[];
                figure
                hold on
                for ket=1:size_alpha(1)
                    Lc_cont(:,ket)=(Gen_lmd_Hist(round(alpha(ket)*Nmp),:)-mean(Gen_lmd_Hist))';
                    Lin_fit = polyfit(lmd2,Lc_cont(:,ket),1);
                    Lc_line=cat(1,Lc_line,Lin_fit);
                    
                    y1 = polyval(Lin_fit,lmd2);
                    
                    plot(lmd2,Lc_cont(:,ket),'o')
                    hold on
                    plot(lmd2,y1)
                    %hold off
                end
                title(fign);
                saveas(gcf,cat(2,fign,'.pdf'));
                %savefig(fign);
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

        % Value changed function: hpCCSwitch
        function hpCCSwitchValueChanged(app, event)
            %value = app.hpCCSwitch.Value;
            if strcmp(app.hpCCSwitch.Value, 'Yes')
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
            app.UIFigure.Position = [100 100 345 670];
            app.UIFigure.Name = 'MATLAB App';

            % Create SummarySwitchLabel
            app.SummarySwitchLabel = uilabel(app.UIFigure);
            app.SummarySwitchLabel.HorizontalAlignment = 'center';
            app.SummarySwitchLabel.Position = [29 226 57 30];
            app.SummarySwitchLabel.Text = 'Summary';

            % Create SummarySwitch
            app.SummarySwitch = uiswitch(app.UIFigure, 'slider');
            app.SummarySwitch.Items = {'No', 'Yes'};
            app.SummarySwitch.ValueChangedFcn = createCallbackFcn(app, @SummarySwitchValueChanged, true);
            app.SummarySwitch.Position = [134 231 52 23];
            app.SummarySwitch.Value = 'Yes';

            % Create RunButton
            app.RunButton = uibutton(app.UIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.FontSize = 14;
            app.RunButton.FontWeight = 'bold';
            app.RunButton.Position = [83 26 100 100];
            app.RunButton.Text = 'Run';

            % Create ConversionfactortocountsEditFieldLabel
            app.ConversionfactortocountsEditFieldLabel = uilabel(app.UIFigure);
            app.ConversionfactortocountsEditFieldLabel.HorizontalAlignment = 'right';
            app.ConversionfactortocountsEditFieldLabel.Position = [24 570 152 22];
            app.ConversionfactortocountsEditFieldLabel.Text = 'Conversion factor to counts';

            % Create ConversionfactortocountsEditField
            app.ConversionfactortocountsEditField = uieditfield(app.UIFigure, 'numeric');
            app.ConversionfactortocountsEditField.Position = [191 570 100 22];

            % Create ThresholdlowerboundaryEditFieldLabel
            app.ThresholdlowerboundaryEditFieldLabel = uilabel(app.UIFigure);
            app.ThresholdlowerboundaryEditFieldLabel.HorizontalAlignment = 'right';
            app.ThresholdlowerboundaryEditFieldLabel.Position = [32 530 144 22];
            app.ThresholdlowerboundaryEditFieldLabel.Text = 'Threshold lower boundary';

            % Create ThresholdlowerboundaryEditField
            app.ThresholdlowerboundaryEditField = uieditfield(app.UIFigure, 'numeric');
            app.ThresholdlowerboundaryEditField.Position = [191 530 100 22];
            app.ThresholdlowerboundaryEditField.Value = 3;

            % Create TruetofalsepositiveratioEditFieldLabel
            app.TruetofalsepositiveratioEditFieldLabel = uilabel(app.UIFigure);
            app.TruetofalsepositiveratioEditFieldLabel.HorizontalAlignment = 'right';
            app.TruetofalsepositiveratioEditFieldLabel.Position = [34 490 142 22];
            app.TruetofalsepositiveratioEditFieldLabel.Text = 'True to false positive ratio';

            % Create TruetofalsepositiveratioEditField
            app.TruetofalsepositiveratioEditField = uieditfield(app.UIFigure, 'numeric');
            app.TruetofalsepositiveratioEditField.Position = [191 490 100 22];
            app.TruetofalsepositiveratioEditField.Value = 40;

            % Create SmoothingwindowEditFieldLabel
            app.SmoothingwindowEditFieldLabel = uilabel(app.UIFigure);
            app.SmoothingwindowEditFieldLabel.HorizontalAlignment = 'right';
            app.SmoothingwindowEditFieldLabel.Position = [70 450 106 22];
            app.SmoothingwindowEditFieldLabel.Text = 'Smoothing window';

            % Create SmoothingwindowEditField
            app.SmoothingwindowEditField = uieditfield(app.UIFigure, 'numeric');
            app.SmoothingwindowEditField.Position = [191 450 100 22];
            app.SmoothingwindowEditField.Value = 50;

            % Create StartdatapointEditFieldLabel
            app.StartdatapointEditFieldLabel = uilabel(app.UIFigure);
            app.StartdatapointEditFieldLabel.HorizontalAlignment = 'right';
            app.StartdatapointEditFieldLabel.Position = [89 410 87 22];
            app.StartdatapointEditFieldLabel.Text = 'Start data point';

            % Create StartdatapointEditField
            app.StartdatapointEditField = uieditfield(app.UIFigure, 'numeric');
            app.StartdatapointEditField.Position = [191 410 100 22];

            % Create Datafileformath5orcsvDropDownLabel
            app.Datafileformath5orcsvDropDownLabel = uilabel(app.UIFigure);
            app.Datafileformath5orcsvDropDownLabel.HorizontalAlignment = 'right';
            app.Datafileformath5orcsvDropDownLabel.Position = [30 299 147 22];
            app.Datafileformath5orcsvDropDownLabel.Text = 'Data file format (h5 or csv)';

            % Create Datafileformath5orcsvDropDown
            app.Datafileformath5orcsvDropDown = uidropdown(app.UIFigure);
            app.Datafileformath5orcsvDropDown.Items = {'HDF5 (h5)', 'CSV'};
            app.Datafileformath5orcsvDropDown.Position = [192 299 100 22];
            app.Datafileformath5orcsvDropDown.Value = 'HDF5 (h5)';

            % Create EnddatapointEditFieldLabel
            app.EnddatapointEditFieldLabel = uilabel(app.UIFigure);
            app.EnddatapointEditFieldLabel.HorizontalAlignment = 'right';
            app.EnddatapointEditFieldLabel.Position = [93 370 83 22];
            app.EnddatapointEditFieldLabel.Text = 'End data point';

            % Create EnddatapointEditField
            app.EnddatapointEditField = uieditfield(app.UIFigure, 'numeric');
            app.EnddatapointEditField.Position = [191 370 100 22];

            % Create NumberofRunspersampleEditFieldLabel
            app.NumberofRunspersampleEditFieldLabel = uilabel(app.UIFigure);
            app.NumberofRunspersampleEditFieldLabel.HorizontalAlignment = 'right';
            app.NumberofRunspersampleEditFieldLabel.Position = [20 330 156 22];
            app.NumberofRunspersampleEditFieldLabel.Text = 'Number of Runs per sample';

            % Create NumberofRunspersampleEditField
            app.NumberofRunspersampleEditField = uieditfield(app.UIFigure, 'numeric');
            app.NumberofRunspersampleEditField.Position = [191 330 100 22];
            app.NumberofRunspersampleEditField.Value = 1;

            % Create ReadsettingfromExcelMDEFSwitchLabel
            app.ReadsettingfromExcelMDEFSwitchLabel = uilabel(app.UIFigure);
            app.ReadsettingfromExcelMDEFSwitchLabel.HorizontalAlignment = 'center';
            app.ReadsettingfromExcelMDEFSwitchLabel.Position = [13 615 170 22];
            app.ReadsettingfromExcelMDEFSwitchLabel.Text = 'Read setting from Excel MDEF';

            % Create ReadsettingfromExcelMDEFSwitch
            app.ReadsettingfromExcelMDEFSwitch = uiswitch(app.UIFigure, 'slider');
            app.ReadsettingfromExcelMDEFSwitch.Items = {'No', 'Yes'};
            app.ReadsettingfromExcelMDEFSwitch.Position = [205 610 73 32];
            app.ReadsettingfromExcelMDEFSwitch.Value = 'No';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [216 26 100 100];
            app.Image.ImageSource = 'splash.png';

            % Create DLampLabel
            app.DLampLabel = uilabel(app.UIFigure);
            app.DLampLabel.HorizontalAlignment = 'right';
            app.DLampLabel.Position = [258 269 25 22];
            app.DLampLabel.Text = 'D';

            % Create DLamp
            app.DLamp = uilamp(app.UIFigure);
            app.DLamp.Position = [298 269 20 20];
            app.DLamp.Color = [0.651 0.651 0.651];

            % Create SLampLabel
            app.SLampLabel = uilabel(app.UIFigure);
            app.SLampLabel.HorizontalAlignment = 'right';
            app.SLampLabel.Position = [258 228 25 22];
            app.SLampLabel.Text = 'S';

            % Create SLamp
            app.SLamp = uilamp(app.UIFigure);
            app.SLamp.Position = [298 227 20 20];
            app.SLamp.Color = [0.651 0.651 0.651];

            % Create CLampLabel
            app.CLampLabel = uilabel(app.UIFigure);
            app.CLampLabel.HorizontalAlignment = 'right';
            app.CLampLabel.Position = [258 189 25 22];
            app.CLampLabel.Text = 'C';

            % Create CLamp
            app.CLamp = uilamp(app.UIFigure);
            app.CLamp.Position = [298 189 20 20];
            app.CLamp.Color = [0.651 0.651 0.651];

            % Create DetectionSwitchLabel
            app.DetectionSwitchLabel = uilabel(app.UIFigure);
            app.DetectionSwitchLabel.HorizontalAlignment = 'center';
            app.DetectionSwitchLabel.Position = [28 267 56 22];
            app.DetectionSwitchLabel.Text = 'Detection';

            % Create DetectionSwitch
            app.DetectionSwitch = uiswitch(app.UIFigure, 'slider');
            app.DetectionSwitch.Items = {'No', 'Yes'};
            app.DetectionSwitch.ValueChangedFcn = createCallbackFcn(app, @DetectionSwitchValueChanged, true);
            app.DetectionSwitch.Position = [134 268 52 23];
            app.DetectionSwitch.Value = 'Yes';

            % Create hpCCSwitchLabel
            app.hpCCSwitchLabel = uilabel(app.UIFigure);
            app.hpCCSwitchLabel.HorizontalAlignment = 'center';
            app.hpCCSwitchLabel.Position = [21 183 74 30];
            app.hpCCSwitchLabel.Text = 'hpCC';

            % Create hpCCSwitch
            app.hpCCSwitch = uiswitch(app.UIFigure, 'slider');
            app.hpCCSwitch.Items = {'No', 'Yes'};
            app.hpCCSwitch.ValueChangedFcn = createCallbackFcn(app, @hpCCSwitchValueChanged, true);
            app.hpCCSwitch.Position = [134 188 52 23];
            app.hpCCSwitch.Value = 'Yes';

            % Create Lamp
            app.Lamp = uilamp(app.UIFigure);
            app.Lamp.Position = [237 97 18 18];
            app.Lamp.Color = [1 1 1];

            % Create QuantClusteringSwitchLabel
            app.QuantClusteringSwitchLabel = uilabel(app.UIFigure);
            app.QuantClusteringSwitchLabel.HorizontalAlignment = 'center';
            app.QuantClusteringSwitchLabel.Position = [5 143 104 30];
            app.QuantClusteringSwitchLabel.Text = 'Quant.&Clustering';

            % Create QuantClusteringSwitch
            app.QuantClusteringSwitch = uiswitch(app.UIFigure, 'slider');
            app.QuantClusteringSwitch.Items = {'No', 'Yes'};
            app.QuantClusteringSwitch.Position = [132 146 52 23];
            app.QuantClusteringSwitch.Value = 'No';

            % Create HCLampLabel
            app.HCLampLabel = uilabel(app.UIFigure);
            app.HCLampLabel.HorizontalAlignment = 'right';
            app.HCLampLabel.Position = [258 146 25 22];
            app.HCLampLabel.Text = 'HC';

            % Create HCLamp
            app.HCLamp = uilamp(app.UIFigure);
            app.HCLamp.Position = [298 146 20 20];
            app.HCLamp.Color = [0.651 0.651 0.651];

            % Create SISLampLabel
            app.SISLampLabel = uilabel(app.UIFigure);
            app.SISLampLabel.HorizontalAlignment = 'right';
            app.SISLampLabel.Position = [201 268 41 22];
            app.SISLampLabel.Text = 'SIS';

            % Create SISLamp
            app.SISLamp = uilamp(app.UIFigure);
            app.SISLamp.Position = [245 268 20 20];
            app.SISLamp.Color = [0.651 0.651 0.651];

            % Create NanoFinder559Label
            app.NanoFinder559Label = uilabel(app.UIFigure);
            app.NanoFinder559Label.Position = [216 5 98 22];
            app.NanoFinder559Label.Text = 'NanoFinder 5.5.9';

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
