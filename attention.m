TG_DATA_ATTENTION = 2;
%Matlab code to read attention using Mindwave Mobile
%Clear Screen
clc;
%Clear Variables
clear all;
%Close figures
close all;
%Preallocate buffer
data_att = zeros(1,256);
%Comport Selection
portnum1 = 4;
%COM Port #
comPortName1 = sprintf('\\\\.\\COM%d', portnum1);
% Baud rate for use with TG_Connect() and TG_SetBaudrate().
TG_BAUD_115200 = 115200;
% Data format for use with TG_Connect() and TG_SetDataFormat().
TG_STREAM_PACKETS = 0;
% Data type that can be requested from TG_GetValue().
TG_DATA_ATTENTION = 2;
%load thinkgear dll
loadlibrary('thinkgear64.dll');
%To display in Command Window
fprintf('thinkgear64.dll loaded\n');
%get dll version
%dllVersion = calllib('thinkgear64', 'TG_GetDriverVersion');
%To display in command window
%fprintf('thinkgear64 DLL version: %d\n', dllVersion );
% Get a connection ID handle to ThinkGear
connectionId1 = calllib('thinkgear64', 'TG_GetNewConnectionId');
if ( connectionId1 < 0 )
error( sprintf( 'ERROR: TG_GetNewConnectionId() returned %d.\n', connectionId1 ) );
end
% Attempt to connect the connection ID handle to serial port "COM3"
errCode = calllib('thinkgear64', 'TG_Connect', connectionId1,comPortName1,TG_BAUD_115200,TG_STREAM_PACKETS );
if ( errCode < 0 )
error( sprintf( 'ERROR: TG_Connect() returned %d.\n', errCode ) );
end
fprintf( 'Connected. Reading Packets...\n' );
i=0;
j=0;
%To display in Command Window
disp('Reading Brainwaves');
figure;
while i < 20
if (calllib('thinkgear64','TG_ReadPackets',connectionId1,1) == 1) %if a packet was read...
if (calllib('thinkgear64','TG_GetValueStatus',connectionId1,TG_DATA_ATTENTION ) ~= 0)
j = j + 1;
i = i + 1;
%Read attention Valus from thinkgear packets
data_att(j) = calllib('thinkgear64','TG_GetValue',connectionId1,TG_DATA_ATTENTION );
%To display in Command Window
disp(data_att(j));
%Plot Graph
plot(data_att);
title('Attention');
%Delay to display graph
pause(1);
end
end
end
%To display in Command Window
disp('Loop Completed')
%Release the comm port
calllib('thinkgear64', 'TG_FreeConnection', connectionId1 );