clc;
close all;
clear ;
input_file = fopen('floating_point_input.txt','w');         %create a new file
output_file = fopen('floating_point_output.txt','w');

input_file1 = fopen('floating_point_input.txt','a');        %append the file
output_file1 = fopen('floating_point_output.txt','a');
Array_no = [43.5, -323, 72.0625, -585, 777.75, 1028, 4096, 1, 0.8125, 10, 20, 30.5, 4444, -67.8, -67.8, 100, 200, 3, 174, 174, 135, 135, 23, 89, 444, 89, 34, 9000, 2222, 8999, 101, 203, 2, 3, 4, 7, 8 , 8.8, 9.8, 9090, 23, 34, 56, 78, 1009, 2023, 2024, 2005, 2002, 2001];  %create an array with 100 numbers

%normalize the first and the second element and write it in the input file
%add them together and normalize to write it in the output file

for i = 1: length(Array_no)-1
    reset1 = '0';
    enable1 = '1';
    S = Signbit(Array_no(i));                       
    Abs_val = AbsoluteVal(Array_no(i));
    FP = Binaryconv(Abs_val);
    NFP = Normalizingfp(S,FP, Abs_val);

    S2 = Signbit(Array_no(i+1));
    Abs_val2 = AbsoluteVal(Array_no(i+1));
    FP2 = Binaryconv(Abs_val2);
    NFP2 = Normalizingfp(S2,FP2, Abs_val2);

     %if i == 1
     %reset1 = '1';
     %enable1 = '0';
     %fprintf(input_file1, '%s %s %s %s\n',reset1, enable1, NFP, NFP2);
     %resetO = repmat('Z',1,32);
     %fprintf(output_file1,resetO);
     %fprintf(output_file1,'\n');
     %end

    fprintf(input_file1, '%s %s %s %s\n',reset1, enable1, NFP, NFP2);

    OutputO = single(Array_no(i)+Array_no(i+1));
    SO = Signbit(OutputO);
    Abs_valO = AbsoluteVal(OutputO);
    FPO = Binaryconv(Abs_valO);
    NFPO = Normalizingfp(SO,FPO, Abs_valO);
    fprintf(output_file1 ,NFPO );
    fprintf(output_file1 ,'\n' );

end

%function to find the Sign bit
function sign_bit = Signbit(number1)
 if number1 >  0
   sign_bit = '0' ;
else
    sign_bit = '1';
 end 
end

%function to find the absolute value of the number
function abs_no = AbsoluteVal(number3)
abs_no = abs(number3);
end

%convert the number to a not normalised binary number
function floating_point = Binaryconv(abs_no)
int_no = floor(abs_no);
fraction1 = abs_no-int_no;
int_bin = dec2bin(int_no);
frac_bin = '';
while fraction1 > 0
    fraction1 = fraction1 *2; 
    if fraction1 >= 1        
        frac_bin = [frac_bin, '1']; 
        fraction1 = fraction1 -1 ;    
    else
        frac_bin = [frac_bin, '0'];  
    end 
end
if int_bin == 0
    floating_point= ['0.',frac_bin];
else 
    floating_point = [int_bin,'.',frac_bin];
end
end


%passs the sign, binary number, the absolute value as parameters and turn it to
%normalised number 
function normalizedfp = Normalizingfp(sign_bit1, binaryno,abs)
indexofpoint = find(binaryno=='.',1);
binaryno = strrep(binaryno, '.', '');
indexof1 = find(binaryno == '1', 1);
normal_no = insertAfter(binaryno, indexof1, '.');
if abs < 1
    extra = indexof1-indexofpoint+1;
    index = 127-extra;
else
    index = 127+indexofpoint-indexof1-1;        
end
exp = dec2bin(index);
exponent = pad(exp, 8, 'left','0');
parts = strsplit(normal_no, '.');
fraction1 = parts{2};
mantissa = pad(fraction1, 23, 'right', '0');
normalizedfp= strcat(sign_bit1,exponent,mantissa);
end



