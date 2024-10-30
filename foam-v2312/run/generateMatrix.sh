#!/bin/bash

# Define the output file
output_file="parameterMatrix"

# Clear the file if it exists
> $output_file

# Define constant values for the parameters (all as floats)
DT=33.49e-6
nu=22.97e-6
Ts=10
T0=0
beta=2.70e-3
g=-9.81
Tw=10
cell_x=100
cell_y=1
cell_z=1
s=0.1
b=0.1
L=0.1
n=3
a=0
phi=0
numberOfSubdomains=2
ux_mag=10

# Get the variable to vary, its min, max, and number of steps from command line arguments
variable_to_vary=Ts  # e.g., Ts, DT, nu, etc.
min_value=1         # e.g., minimum value (logarithmic start)
max_value=9.999         # e.g., maximum value (logarithmic end)
num_steps=20         # e.g., number of steps

# If any argument is missing, show usage and exit
if [ -z "$variable_to_vary" ] || [ -z "$min_value" ] || [ -z "$max_value" ] || [ -z "$num_steps" ]; then
    echo "Usage: $0 <variable_to_vary> <min_value> <max_value> <num_steps>"
    exit 1
fi

# Generate logarithmic values for the selected variable (using float precision)
log_values=$(awk -v min=$min_value -v max=$max_value -v steps=$num_steps 'BEGIN {
    for (i=0; i<steps; i++) {
        print min * (max/min)^(i/(steps-1))
    }
}')

# Write the header to the file
printf "DT          nu          Ts         T0  beta        g       Tw  cell_x  cell_y  cell_z  s         b         L         n   a   phi     numberOfSubdomains  ux_mag" >> $output_file

# Loop through each logarithmic value and update the selected variable
for value in $log_values; do
    # Set the variable to vary with the new value (as a float)
    case $variable_to_vary in
        DT) DT=$value ;;
        nu) nu=$value ;;
        Ts) Ts=$value ;;
        T0) T0=$value ;;
        beta) beta=$value ;;
        g) g=$value ;;
        Tw) Tw=$value ;;
        cell_x) cell_x=$value ;;
        cell_y) cell_y=$value ;;
        cell_z) cell_z=$value ;;
        s) s=$value ;;
        b) b=$value ;;
        L) L=$value ;;
        n) n=$value ;;
        a) a=$value ;;
        phi) phi=$value ;;
        numberOfSubdomains) numberOfSubdomains=$value ;;
        ux_mag) ux_mag=$value ;;
        *)
            echo "Error: Unknown variable '$variable_to_vary'"
            exit 1
            ;;
    esac

    # Write the line with updated values to the file (using float formatting)
    printf "\n%-12.6e %-12.6e %-12.6f %-3d %-10.6e %-7.2f %-4.1f %-7.1f %-7.1f %-7.1f %-8.1f %-8.1f %-8.1f %-4d %-3.1f %-4.1f %-20d %-6.1f" \
        "$DT" "$nu" "$Ts" "$T0" "$beta" "$g" "$Tw" "$cell_x" "$cell_y" "$cell_z" "$s" "$b" "$L" "$n" "$a" "$phi" "$numberOfSubdomains" "$ux_mag" \
        >> $output_file
done

echo "File '$output_file' generated successfully."