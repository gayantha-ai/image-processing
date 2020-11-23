function newcap

f=imread('img/car3.jpg');%Reading the no plate

f=imresize(f,[400 NaN]); %resize the image

g=rgb2gray(f); %converting rgb image to gray scale

g=medfilt2(g,[3 3]); %median filter to remove noise

se=strel('disk',1); %structural element for morphological processing

gi=imdilate(g,se); %dilating the gray image

ge=imerode(g,se); %eroding the gray image

gdiff=imsubtract(gi,ge); %morphological gradient for edges

gdiff=mat2gray(gdiff); %converting the class to double

gdiff=conv2(gdiff,[1 1;1 1]); %convolution of the double image

gdiff=imadjust(gdiff,[0.5 0.7],[0 1],0.1); %intensity scalling between the range 0 to 1

B=logical(gdiff); %convertion of the class from double to binary



er=imerode(B,strel('line',50,0));

out1=imsubtract(B,er);

F=imfill(out1,'holes'); %Filling regions of the image

H=bwmorph(F,'thin',1);  %Thinning the image
H=imerode(H,strel('line',3,90));

final=bwareaopen(H,100);

Iprops=regionprops(final,'BoundingBox','Image');  %bounnding boxes

NR=cat(1,Iprops.BoundingBox);  %selecting all the bounding boxes

r=controlling(NR);  %calling of controlling function


if ~isempty(r) %if successfully indices of desired boxes
    I={Iprops.Image};
    noPlate=[];  %intializing the variables of number plates
    for v=1:length(r)
        N=I{1,r(v)}; %extracting the binary image
        letter=readLetter(N);  %reading the letter
        while letter=='O' || letter=='0'  %since it would
            if v<=3                       %between 'O' and '0' during extraction of character
                letter='O';
            else
                letter='0';
            end
            break;
        end
        
        noPlate=[noPlate letter];  %appending every subsequent char in noplate variables
    end
    
    fid=fopen('newcapture.txt','w'); %opening text file and giving access to write
    fprintf(fid,'%s\t',noPlate);  %writing on the text file
    fclose(fid);  %closing the text file
    winopen('newcapture.txt');
end
    
    
end



