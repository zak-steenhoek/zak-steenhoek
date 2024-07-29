function T_Accel = Gf_to_Accel(T_Gf, Header)
    %Divide all gforce values by gravity to get accel values
    T_Accel = T_Gf./[1 9.81 9.81 9.81 9.81];
    %Rename variables
    T_Accel.Properties.VariableNames = Header;
end