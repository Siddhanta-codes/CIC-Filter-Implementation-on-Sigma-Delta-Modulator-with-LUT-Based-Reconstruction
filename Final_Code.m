fs=750000;
fin=75;
A=0.9;
t=0:1/fs:1/fin;
x=A*sin(2*pi*fin*t);
N=length(x);
bitstream = zeros(1,N);

error1=0; int1=0;
error2=0; int2=0;
dac=0;
for i=1:N
    error1 = x(i)-dac;
    int1 = int1 + error1;
    error2 = int1-dac;
    int2 = int2+ error2;
    comp = int2>=0;
    bitstream(i) = comp;

    dac = bitstream(i)*2-1;
end

%CIC
D=128; R=128;

x_cic = bitstream*2-1;
num_stages = 3;
int=zeros(1,num_stages);
int_out = zeros(1,N);

bit_size = 32;
max_val = 2^bit_size;

for i=1:N
    int(1) = (int(1)+x_cic(i));
    for stages = 2:num_stages
        int(stages) = (int(stages)+int(stages-1));
    end
    int_out(i) = int(end);
end
figure
subplot(4,1,1);
plot(t, int_out);

%downsample
downsampled = int_out(1:R:end);
t_down = t(1:R:end);
subplot(4,1,2);
plot(t_down, downsampled);

%comb
comb_out = downsampled;
for i=1:num_stages
    comb_out = diff(comb_out, D/R); 
end
t_comb = t(1:length(comb_out));
subplot(4,1,3);
plot(t_comb, comb_out);

%Converting Generated Bitstream into Matrix
total_bytes = floor(N/8);
byte_matrix = zeros(total_bytes, 8);

for i=1:total_bytes
    for j=1:8
        byte_matrix(i,j) = bitstream((i-1)*8+j);
    end
end

%Generate LUTs for each integrator stage
LUT1 = zeros(256,1);
LUT2 = zeros(256,1);
LUT3 = zeros(256,1);

for i=0:255
    sample_bits = bitget(i, 8:-1:1);
    %sample_bits = sample_bits*2-1;
   

    i1=0; i2=0; i3=0;
    for k=1:8
        i1 = i1+sample_bits(k);
        i2 = i2+ i1;
        i3 = i3+ i2;
    end
    LUT1(i+1) = i1;
    LUT2(i+1) = i2;
    LUT3(i+1) = i3;
end

%Converting Bitstream into Decimal Form in order to get the
%subsequent row number for the LUTs
i1=0;
i2=0;
i3=0;
lut1_out = zeros(total_bytes,1);
lut2_out = zeros(total_bytes,1);
lut3_out = zeros(total_bytes,1);

for i=1:total_bytes
    bits = byte_matrix(i,:);
    decimal_val=0;
    for j=1:8
        decimal_val = decimal_val + (bits(j)*2^(8-j));
    end

    i1_new = LUT1(decimal_val+1);
    i2_new = LUT2(decimal_val+1)+ 8*i1;
    i3_new = LUT3(decimal_val+1) + 8*i2 + 36*i1;

    i1 = i1_new;
    i2 = i2_new;
    i3 = i3_new;


    lut1_out(i) = i1;
    lut2_out(i) = i2;
    lut3_out(i) = i3;
end

reconstructed = lut3_out; 
t_reconst = t(1:length(reconstructed));
subplot(4,1,4)
plot(t_reconst, reconstructed)
