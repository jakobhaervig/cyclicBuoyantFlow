import numpy as np
from matplotlib import pyplot as plt
import pathlib
import sys

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
prefix = 'verticalChannel_'
cwd = pathlib.Path.cwd()

for folder in cwd.iterdir():
    if folder.is_dir() and folder.name.startswith(prefix):
        if folder / 'log.pimpleFoam' in folder.iterdir():
            vars = folder / 'parms'
            vars = load_variables(vars)
            Gr = np.abs(vars["g"])*vars["beta"]*(vars["Tw"]-vars["T0"])*vars["b"]**3/vars["nu"]**2
            Pr = vars["nu"]/vars["DT"]
            t = np.loadtxt(folder / 't')
            psi = np.loadtxt(folder / 'psi')
            dtdn = np.loadtxt(folder / 'dtdn')

            # Slice t and psi to the same length
            min_length = min(len(t), len(psi), len(dtdn))
            t = t[:min_length]
            psi = psi[:min_length]
            dtdn = dtdn[:min_length]

            plt.semilogx(vars["nu"]**2/(vars["beta"]*np.abs(vars["g"])*vars["b"]*3*(vars["Tw"]-vars["Ts"])), (psi[-1]*(vars['b']/vars["nu"])/Gr), label='{0}'.format(folder.name), marker='o')

#plt.xlabel('Time (s)')
plt.ylabel(r'Dimensionless massflow $\Psi$')
#plt.hlines(1/12*Gr, 0, t[-1], color='black', label=r'Gr/12')
plt.legend()
plt.grid('both')
plt.show()
