%% Connecting to Port

clear;
instrreset; %delete all objects and connections
% default baud rate of 9600.
adafruit = serialport("COM5",9600) %connect to serial port 5 - might differ for different computers (check in the device manager)
%% Capturing data

runtime = 15; %seconds
refresh_time = 0.2; %seconds


dataold = nan %empty value
for i=1:runtime/refresh_time
    Avail = adafruit.NumBytesAvailable; %getting the number of bytes available
        datatemp = read(adafruit,Avail,"string"); %fetching data
        %%cleaning the data up
        datamod1 = replace(datatemp,"channel 1 raw value:","");
        datamod2 = split(datamod1,newline);
        strip(datamod2);
        %handling any non numerical values in the while loop
        [rd,~]=size(datamod2);
        i=1;
        while i < rd+1
            if contains(datamod2(i),'code.py') || strcmp(datamod2(i),"")
                datamod2(i) = []; %deleting that particular value
                [rd,~]=size(datamod2); %updating the size value
                i=i-1; %decrementing index to keep preserve same value for next iteration    
            end
            i=i+1;
        end
    datanum = str2double(datamod2); %converting str to num
    data = [dataold;datanum]; %appending the data to old data
    dataold = data; 
    [r,c] = size(data);
    t = linspace(1,r,r);
    plot(t,data)
    pause(refresh_time)
end 
%% Section to disconnect
serialportfind
