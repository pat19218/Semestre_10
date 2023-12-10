# ============================================================================
# MT3006 - LABORATORIO 4
# ----------------------------------------------------------------------------
# En este problema usted debe emplear tensorflow para construir y entrenar una
# red neuronal convolucional simple, para encontrar un modelo que permita 
# clasificar imágenes de las letras A, B y C. 
# ============================================================================
import tensorflow as tf
import numpy as np
from matplotlib import pyplot
from matplotlib import rcParams
from scipy import io

# Se ajusta el tamaño de letra y de figura
rcParams.update({'font.size': 18})
pyplot.rcParams['figure.figsize'] = [12, 12]

# Se carga la data de entrenamiento y validación desde los archivos .mat
lettersTrain = io.loadmat('lettersTrainSet.mat')
lettersTest = io.loadmat('lettersTestSet.mat')

# Se extraen las observaciones de entrenamiento y validación. La data importada
# presenta las dimensiones (alto, ancho, canales, batch). En este caso se tiene
# sólo un canal dado que las imágenes son en escala de grises.
XTrain = lettersTrain['XTrain']
XTest = lettersTest['XTest']
# Se extraen las labels de entrenamiento y validación, estas están dadas en 
# forma de un array de chars indicando la letra a la que corresponden: 'A', 
# 'B' y 'C'.
TTrain = lettersTrain['TTrain_cell']
TTest = lettersTest['TTest_cell']
#print(TTrain)

# Se obtiene un vector con 20 índices aleatorios entre 0 y 1500-1 para obtener
# los ejemplos de imagen a visualizar. 
perm = np.random.permutation(1500)[:20]

# Se re-arregla la data de entrada para que presente las dimensiones (batch, 
# alto, ancho, canales) ya que es la forma en la que Keras la espera por 
# defecto
XTrain = np.transpose(XTrain, axes = [3,0,1,2])
XTest = np.transpose(XTest, axes = [3,0,1,2])

# Se grafican 20 ejemplos de imagen seleccionados aleatoriamente
fig,axs = pyplot.subplots(4,5)
axs = axs.reshape(-1)

for j in range(len(axs)):
    axs[j].imshow(np.squeeze(XTrain[perm[j],:,:,:]),cmap='gray')
    axs[j].axis('off')

    
pyplot.tight_layout()
pyplot.show()

# Se extraen las categorías como los valores únicos (diferentes) del array 
# original de labels
classes = np.unique(TTrain)
# Se crean arrays de ceros con las mismas dimensiones de los arrays originales
# de labels
YTrainLabel = np.zeros_like(TTrain)
YTestLabel = np.zeros_like(TTest)

# Se convierte la categoría desde una letra 'A', 'B', 'C' a un número 0, 1 o 2
# respectivamente
for nc in range(len(classes)):
    YTrainLabel[TTrain == classes[nc]] = nc
    YTestLabel[TTest == classes[nc]] = nc

# Se elimina la dimensión "adicional" de los vectores para poder hacer un 
# one-hot encoding con la misma en Keras
YTrainLabel = YTrainLabel.reshape(-1)
YTestLabel = YTestLabel.reshape(-1)
    
# Se efectúa un one-hot encoding para las labels
YTrain = tf.keras.utils.to_categorical(YTrainLabel)
YTest = tf.keras.utils.to_categorical(YTestLabel)
#print(YTrain)

# COMPLETAR: definición, entrenamiento y evaluación del modelo.
# NOTA: durante la predicción puede emplear la función argmax de numpy para
# deshacer el one-hot encoding

#------------------------------------------------------------------------------
#	Modelo de red neuronal convolucional
#------------------------------------------------------------------------------

#Creamos la estructura que contendra nuestro modelo
model = tf.keras.Sequential()

#Creamos las capas. CONVOLUCIONAL; MAX POOLING; FLATTEN; DENSE

# (kernels, size_kernel, (size_input_image & numbers_chanels), activation )
#						1 = gray
layer1 = tf.keras.layers.Conv2D(32, (5,5), input_shape=(28,28,1), activation='relu')
# 					(pool_size, saltos)
layer2 = tf.keras.layers.MaxPooling2D(pool_size=(10, 10), strides=(10,10))
layer3 = tf.keras.layers.Flatten() #convierte a vec_columna, no afecta shape
layer4 = tf.keras.layers.Dense(3, activation='softmax')
layer5 = tf.keras.layers.Dropout(0.5) #agregar antes de flatten para mejorar

#Agregamos las capas al modelo
model.add(layer1)	#convolucion
model.add(layer2)	#Max pooling
model.add(layer5)	#Dropout (apaga aleatoriamente neuronas)
model.add(layer3)	#Flatten
model.add(layer4)	#Dense

#------------------------------------------------------------------------------
#	red neuronal convolucional
#------------------------------------------------------------------------------

#Se compila el modelo
lr = 0.001 #learning rate
my_sgd= tf.keras.optimizers.SGD(learning_rate=lr, momentum=0.92)
my_CCE= tf.keras.losses.CategoricalCrossentropy()
model.compile(loss='mse', optimizer=my_sgd, metrics=['accuracy'])

#Entrenamos el modelo
history = model.fit(XTrain, YTrain, epochs=30, validation_data=[XTest,YTest])

# Evaluar el modelo (opcional)
loss = model.evaluate(XTest,  YTest, verbose=2)
print("Pérdida en el conjunto de entrenamiento:", loss)

# Realizar inferencia con el modelo
#nnPredictions = model.predict(nnInput)

#------------------------------------------------------------------------------
#	Resultados
#------------------------------------------------------------------------------

yhat = model.predict(XTest)
yhat_class = np.argmax(yhat,axis=1)
yes_class = np.argmax(YTest, axis=1)
# Se obtiene la matriz de confusión para el set de validación
confusion = tf.math.confusion_matrix(yes_class,yhat_class)
print("\nMatriz de confusion: ")
print(confusion)

# Se grafica la evolución de la pérdida durante el entrenamiento y la 
# validación
pyplot.subplot(211)
pyplot.title('Loss')
pyplot.plot(history.history['loss'], label='train')
pyplot.plot(history.history['val_loss'], label='test')
pyplot.legend()
# Se grafica la evolución de la exactitud durante el entrenamiento y la 
# validación
pyplot.subplot(212)
pyplot.title('Accuracy')
pyplot.plot(history.history['accuracy'], label='train')
pyplot.plot(history.history['val_accuracy'], label='test')
pyplot.legend()
pyplot.show()

w = model.get_weights()
w = np.array(w[0])
print(w.shape)
kernel1 = w[:,:,:,1]
kernel2 = w[:,:,:,2]
kernel3 = w[:,:,:,3]
kernel4 = w[:,:,:,4]
kernel5 = w[:,:,:,5]
kernel6 = w[:,:,:,6]
kernel7 = w[:,:,:,7]
kernel8 = w[:,:,:,8]
kernel9 = w[:,:,:,9]
kernel10 = w[:,:,:,10]
kernel11 = w[:,:,:,11]
kernel12 = w[:,:,:,12]
kernel13 = w[:,:,:,13]
kernel14 = w[:,:,:,14]
kernel15 = w[:,:,:,15]
kernel16 = w[:,:,:,0]

pyplot.subplot(241)
pyplot.imshow(kernel1, cmap = 'gray')

pyplot.subplot(242)
pyplot.imshow(kernel2, cmap = 'gray')

pyplot.subplot(243)
pyplot.imshow(kernel3, cmap = 'gray')

pyplot.subplot(244)
pyplot.imshow(kernel4, cmap = 'gray')

pyplot.subplot(245)
pyplot.imshow(kernel5, cmap = 'gray')

pyplot.subplot(246)
pyplot.imshow(kernel6, cmap = 'gray')

pyplot.subplot(247)
pyplot.imshow(kernel7, cmap = 'gray')

pyplot.subplot(248)
pyplot.imshow(kernel8, cmap = 'gray')

pyplot.show()

pyplot.subplot(241)
pyplot.imshow(kernel9, cmap = 'gray')

pyplot.subplot(242)
pyplot.imshow(kernel10, cmap = 'gray')

pyplot.subplot(243)
pyplot.imshow(kernel11, cmap = 'gray')

pyplot.subplot(244)
pyplot.imshow(kernel12, cmap = 'gray')

pyplot.subplot(245)
pyplot.imshow(kernel13, cmap = 'gray')

pyplot.subplot(246)
pyplot.imshow(kernel14, cmap = 'gray')

pyplot.subplot(247)
pyplot.imshow(kernel15, cmap = 'gray')

pyplot.subplot(248)
pyplot.imshow(kernel16, cmap = 'gray')

pyplot.show()

# Se grafica imagen seleccionada aleatoriamente
fig,axs = pyplot.subplots()
#axs = axs.reshape(-1)

axs.imshow(np.squeeze(XTrain[perm[0],:,:,:]),cmap='gray')
axs.axis('off')
    
pyplot.tight_layout()
pyplot.show()

#print(np.shape(XTrain))	#(1500, 28, 28, 1)
nnPredictions = model.predict(XTrain)

print(nnPredictions[perm[0]])	#A=1,0,0	B=0,1,0		C=0,0,1

letter = np.argmax(nnPredictions[perm[0]])

if letter == 0:
	print("Es: A")
elif letter == 1:
	print("Es: B")
elif letter == 2:
	print("Es: C")














