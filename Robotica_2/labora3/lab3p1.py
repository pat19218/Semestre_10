# ============================================================================
# MT3006 - LABORATORIO 3, PROBLEMA 1
# ----------------------------------------------------------------------------
# En este problema usted debe emplear tensorflow para construir y entrenar un
# perceptrón simple para encontrar un modelo que permita clasificar imágenes 
# de perros (0) y gatos (1). 
# ============================================================================
import tensorflow as tf
import numpy as np
from matplotlib import pyplot
from scipy import io

# Se cargan los archivos mat con la data
dogData = io.loadmat('dog_data.mat')
catData = io.loadmat('cat_data.mat')

# Se extrae la data y se re-dimensionan las imágenes como vectores columna
dogWave = dogData['dog_wave']
catWave = catData['cat_wave']


# Se visualiza un ejemplo de cada una de las dos categorías
dogExample = dogWave[:, 20];
catExample = catWave[:, 20];
dogExample = np.reshape(dogExample, (32,32))
catExample = np.reshape(catExample, (32,32))
pyplot.subplot(121)
pyplot.imshow(dogExample, cmap = 'gray', vmin = 0, vmax = np.amax(dogExample))
pyplot.subplot(122)
pyplot.imshow(catExample, cmap = 'gray', vmin = 0, vmax = np.amax(catExample))
pyplot.show()

# Se crean los sets de entrenamiento y de prueba, junto con las etiquetas
trainSet = np.transpose(np.concatenate((dogWave[:,:60], catWave[:,:60]), axis = 1))
valSet = np.transpose(np.concatenate((dogWave[:,60:80], catWave[:,60:80]), axis = 1))
trainLabels = np.repeat(np.array([0, 1]), 60)
valLabels = np.repeat(np.array([0, 1]), 20)

# *****************************************************************************
# DEFINA EL MODELO AQUÍ
# *****************************************************************************


# *****************************************************************************
# ENTRENE EL MODELO AQUÍ
# *****************************************************************************
history = model.fit()


# Se evalúa el modelo para encontrar la exactitud de la clasificación (tanto 
# durante el entrenamiento y la validación)
_, train_acc = model.evaluate(trainSet, trainLabels, verbose = 0)
_, val_acc = model.evaluate(valSet, valLabels, verbose = 0)
print('Train: %.3f, Test: %.3f' % (train_acc, val_acc))

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

# Se obtienen las predicciones del modelo para el set de validación
yhat = model.predict(valSet)
# Se obtiene la matriz de confusión para el set de validación
confusion = tf.math.confusion_matrix(labels = valLabels, predictions = yhat)
print(confusion)




