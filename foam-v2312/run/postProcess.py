import numpy as np
from matplotlib import pyplot as plt

# Function to load variables from the file with semicolons
def load_variables(filename):
    variables = {}
    with open(filename, 'r') as file:
        for line in file:
            # Strip newline, spaces, and semicolon
            line = line.strip().rstrip(';')
            if line:
                # Split each line by " " and strip extra spaces
                var_name, var_value = line.split(' ')
                var_name = var_name.strip()
                var_value = var_value.strip()

                # Convert string to the appropriate type (float, int, etc.)
                try:
                    if '.' in var_value or 'e' in var_value.lower():
                        variables[var_name] = float(var_value)
                    else:
                        variables[var_name] = int(var_value)
                except ValueError:
                    variables[var_name] = var_value  # In case it's a string or other type
    return variables

# Load the variables from the file
filename = 'verticalChannel_0000/parms'
vars = load_variables(filename)

#Calc Gr and Pr from vars
Gr = -1*(vars["g"]*vars["beta"]*(vars["T_set"]-vars["T0"])*vars["b"]**3)/(vars["nu"]**2)
Pr = vars["nu"]/vars["DT"]

psi = np.genfromtxt(r'verticalChannel_0001/psi', delimiter=' ')
Psi = psi[:,1]*(vars['b']/vars["nu"])

plt.xlabel('Time [s]')
plt.ylabel(r'Dimensionless massflow $\Psi$')

plt.plot(psi[:,0],((Psi-1/12*Gr)/(1/12*Gr))*100, label='non-constant source')
#plt.hlines((1/12*Gr), 0, psi[-1,0], color='red', label='constant source (1/12Gr) Gr={0}'.format(Gr))

plt.grid('both')
plt.legend()
plt.show()
