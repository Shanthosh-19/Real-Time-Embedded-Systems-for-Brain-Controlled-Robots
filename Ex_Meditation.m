
    %Clear Screen
    clc;
    %Clear Variables
    clear all;
    %Close figures
    close all; 
    
    %Preallocate buffer
    data_med = zeros(1,256);    

    %Comport Selection
    portnum1 = 11;  
    %COM Port #
    comPortName1 = sprintf('\\\\.\\COM%d', portnum1);


    % Baud rate for use with TG_Connect() and TG_SetBaudrate().
    TG_BAUD_115200  =   115200;

    % Data format for use with TG_Connect() and TG_SetDataFormat().
    TG_STREAM_PACKETS =     0;
    % Data type that can be requested from TG_GetValue().
    
    TG_DATA_MEDITATION = 3;    
    
    %load thinkgear64 dll
    loadlibrary('thinkgear64.dll');
    
    %To display in Command Window
    fprintf('thinkgear64.dll loaded\n');
    
        % Get a connection ID handle to thinkgear64
    connectionId1 = calllib('thinkgear64', 'TG_GetNewConnectionId');
    if ( connectionId1 < 0 )
        error( sprintf( 'ERROR: TG_GetNewConnectionId() returned %d.\n', connectionId1 ) );
    end;


    % Attempt to connect the connection ID handle to serial port "COM3"
    errCode = calllib('thinkgear64', 'TG_Connect',  connectionId1,comPortName1,TG_BAUD_115200,TG_STREAM_PACKETS );
    if ( errCode < 0 )
        error( sprintf( 'ERROR: TG_Connect() returned %d.\n', errCode ) );
    end

    fprintf( 'Connected.  Reading Packets...\n' );

    
    i=0;
    j=0;
   
    %To display in Command Window

    disp('Reading Brainwaves');

    figure;
    while i < 50
        if (calllib('thinkgear64','TG_ReadPackets',connectionId1,1) == 1)   %if a packet was read...
            if (calllib('thinkgear64','TG_GetValueStatus',connectionId1,TG_DATA_MEDITATION ) ~= 0) 
                j = j + 1;
                i = i + 1;
                %Read attention Valus from thinkgear64 packets
                data_med(j) = calllib('thinkgear64','TG_GetValue',connectionId1,TG_DATA_MEDITATION );
                %To display in Command Window
                disp(data_med(j));
                %Plot Graph
                plot(data_med);
                
                title('Meditation');
                %Delay to display graph
                pause(1);
            end
       end
    end
    
    %To display in Command Window
    disp('Loop Completed')
    %Release the comm port
    calllib('thinkgear64', 'TG_FreeConnection', connectionId1 );