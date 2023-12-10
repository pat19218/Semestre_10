# ============================================================================
# MT3006 - LABORATORIO 3, PROBLEMA 2
# ----------------------------------------------------------------------------
# En este problema usted debe emplear tensorflow para construir y entrenar una
# red neuronal para identificar un modelo no lineal para el sistema de Lorenz 
# con parámetros tal que exhiba caos. 
# ============================================================================
import tensorflow as tf
import numpy as np
from matplotlib import pyplot
from matplotlib import rcParams
from scipy import integrate

# Se ajusta el tamaño de letra y de figura
rcParams.update({'font.size': 18})
pyplot.rcParams['figure.figsize'] = [12, 12]

# Se efectúa la simulación del sistema Lorenz
dt = 0.01                   # tiempo de muestreo
T = 8                       # tiempo de simulación
t = np.arange(0, T+dt, dt)  # vector de tiempos
# Parámetros del sistema de Lorenz tal que presente caos
beta = 8/3          
sigma = 10
rho = 28

# Definición de la dinámica del sistema de Lorenz
def lorenzDynamics(x_y_z, t0, sigma = sigma, beta = beta, rho = rho):
    x, y, z = x_y_z
    return [sigma * (y - x), x * (rho - z) - y, x * y - beta * z]

# Se preparan los arrays para almacenar la data del sistema Lorenz a generarse
nnInput = np.zeros((100*(len(t)-1), 3))
nnOutput = np.zeros_like(nnInput)

# Se generan 100 condiciones iniciales aleatoriamente para generar 
# trayectorias mediante la solución numérica de la dinámica del sistema

# Se generan 100 condiciones iniciales aleatorias y luego se emplean para 
# generar las trayectorias del sistema Lorenz, integrando numéricamente la 
# dinámica del sistema
np.random.seed(123)
x0 = -15 + 30 * np.random.random((100, 3))
x_t = np.asarray([integrate.odeint(lorenzDynamics, x0_j, t) for x0_j in x0])

# Se grafican las trayectorias generadas y se almacenan los pares 
# entrada(x[k])-salida(x[k+1]) para el entrenamiento posterior de la red 
# neuronal 

fig, ax = pyplot.subplots(1, 1, subplot_kw = {'projection': '3d'})

for j in range(100):
    #selecciono todo los puntos excepto el ultimo
    nnInput[j*(len(t)-1):(j+1)*(len(t)-1),:] = x_t[j,:-1,:] 
    #selecciono todo los puntos excepto el primero
    nnOutput[j*(len(t)-1):(j+1)*(len(t)-1),:] = x_t[j,1:,:]
    x, y, z = x_t[j,:,:].T
    ax.plot(x, y, z,linewidth=1)
    ax.scatter(x0[j,0], x0[j,1], x0[j,2], color='r')
    
#print(np.shape(x_t[20,:,:].T))             

ax.view_init(18, -113)
pyplot.show()
print(np.shape(nnInput))	#(80000, 3) 
print(np.shape(nnOutput))	#(80000, 3)
# COMPLETAR: 
# 1. Definición, entrenamiento y evaluación del modelo.
# 2. Comparación de la simulación obtenida mediante integración numérica con 
#    la obtenida por la red neuronal.

#------------------------------------------------------------------------------
#		red neuronal
#------------------------------------------------------------------------------
model = tf.keras.Sequential()

lr = 0.01 #learning rate
nn = [3,16,8,3] #cantidad de neuronas

#Creamos la estructura que contendra nuestro modelo
model = tf.keras.Sequential()

#Creamos las capas, activacion puede ser: linear  sigmoid  relu
layer1 = tf.keras.layers.Dense(nn[0], activation='relu')
layer2 = tf.keras.layers.Dense(nn[1], activation='tanh')
layer3 = tf.keras.layers.Dense(nn[2], activation='elu')
layer4 = tf.keras.layers.Dense(nn[3], activation='relu')

#Agregamos las capas al modelo
model.add(layer1)
#model.add(layer2)
#model.add(layer3)
#model.add(layer4)

#Se compila el modelo
my_sgd= tf.keras.optimizers.SGD(learning_rate=lr,momentum=0.92)

model.compile(loss='mse', optimizer=my_sgd, metrics=['acc'])

#Entrenamos el modelo
history = model.fit(nnInput, nnOutput, epochs=20)

# Evaluar el modelo (opcional)
loss = model.evaluate(nnInput, nnOutput)
print("Pérdida en el conjunto de entrenamiento:", loss)

# Realizar inferencia con el modelo
#nnPredictions = model.predict(nnInput)
#------------------------------------------------------------------------------
#		Trayectorias
#------------------------------------------------------------------------------

x0 = -15 + 30 * np.random.random((1, 3))

#Trayectorial real
x_t = np.asarray([integrate.odeint(lorenzDynamics, x0_j, t) for x0_j in x0])
x_sim, y_sim, z_sim = x_t[:,:,:].T

#prediccion rnn
nInput = x0

nnTrajectory = []

for j in range(800):
    npredic = model.predict(nInput)
    x_nn = npredic[0, 0]
    y_nn = npredic[0, 1]
    z_nn = npredic[0, 2]
    
    nnTrajectory.append([x_nn, y_nn, z_nn])
    nInput = npredic

nnTrajectory = np.asarray(nnTrajectory)

"""
nInput = x0
for j in range(800):
    npredic= model.predict(nInput)
    x_nn = npredic[j,0]
    y_nn = npredic[j,1]
    z_nn = npredic[j,2]
    #nnTrajectory.append(x_nn, y_nn, z_nn)
    nInput = x_nn, y_nn, z_nn

#npredic = model.predict(x0)
#x_nn = npredic[0,0]
#y_nn = npredic[0,1]
#z_nn = npredic[0,2]
"""
form = x_sim, y_sim, z_sim
rnna = x_nn, y_nn, z_nn

print(np.shape(form))
print(np.shape(rnna))

# Graficar comparación entre simulación numérica e inferencia de la red neuronal en subplots
fig, (ax1, ax2) = pyplot.subplots(1, 2, subplot_kw={'projection': '3d'})

ax1.plot(x_sim, y_sim, z_sim, linewidth=1, label='Simulación numérica')
ax1.scatter(x0[0, 0], x0[0, 1], x0[0, 2], color='r')

#ax2.plot(x_nn, y_nn, z_nn, linewidth=1, linestyle='dashed', label='Inferencia NN')
ax2.plot(nnTrajectory[:, 0], nnTrajectory[:, 1], nnTrajectory[:, 2], linewidth=1, linestyle='dashed', label='Inferencia NN')

ax2.scatter(x0[0, 0], x0[0, 1], x0[0, 2], color='r')

ax1.set_title('Simulación Numérica')
ax1.view_init(18, -113)
ax1.legend()

ax2.set_title('Inferencia de la Red Neuronal')
ax2.view_init(18, -113)
ax2.legend()

pyplot.tight_layout()
pyplot.show()

















