####################################################################################################
# MODELO DE REGRESI�N SIMPLE
####################################################################################################

# --------------------------------------------------------------------------------------------------
# Regresi�n simple usando la funci�n 'lm'
# --------------------------------------------------------------------------------------------------

# Cargamos nuestros datos, los visualizamos
DATOS <- read.csv("datos_ajuste_1.csv")
# DATOS <- rbind( DATOS, data.frame( X = 50, Y = 100 ) ) # Outlier, pero no una observacion influyente
# DATOS <- rbind( DATOS, data.frame( X = 150, Y = 0 ) )  # Outlier, tambi�n una observacion influyente
plot(x = DATOS$X, y = DATOS$Y, main="Datos de Ajuste 1", col="#1CACDB", pch=19); grid()

# Realizamos nuestra regresi�n y graficamos los valores ajustados
MODELO <- lm(formula = Y ~ 1 + X, data = DATOS)
lines(x = DATOS$X, y = MODELO$fitted.values, main="Datos de Ajuste 1", col="red", lwd=2)

# El objeto 'MODELO' tiene informaci�n importante acerca de la regresi�n
MODELO$coefficients    # Coeficientes Estimados de las Betas
MODELO$residuals       # Residuales Estimados (\hat{e_i} = y_i - \hat{y_i})
MODELO$effects         # Valores Projectados a un Espacio Ortogonal (No es de inter�s para el curso)
MODELO$rank            # Rango de la matriz de dise�o
MODELO$fitted.values   # Y Estimadas ( \hat{y_i} )
MODELO$assign          # Atributo para la funci�n Summary (No es de inter�s para el curso)
MODELO$qr              # Objeto con la descomposici�n QR (No es de inter�s para el curso)
MODELO$df.residual     # Grados de libertad (# de observaciones - # betas estimadas)
MODELO$xlevels         # Niveles (�nicamente para regresiones con datos categ�ricos)
MODELO$call            # Relaci�n de Y con X
MODELO$terms           # T�rminos / Atributos
MODELO$model           # Conjunto de datos ingresados

# Podemos hacer un resumen del modelo con la siguiente instrucci�n
# Este resumen nos muestra la significancia de cada t�rmino realizando una prueba de hip�tesis
RESUMEN <- summary( MODELO )
RESUMEN

# Lo primero que debemos notar es el valor del estad�stico R2 el cual indica el porcentaje
# de variabilidad explicada por el modelo. Es una m�trica para decir que tan bueno se ajusta el modelo.
# Esta m�trica va desde 0 a 1. Mientras m�s cercano a uno, indica que ajusta mejor a los puntos.

# Para entender c�mo funciona esta m�trica, debemos recordar la descomposici�n de cuadrados
# SCT = SCE + SCR
# SCT = Suma de Cuadrados Totales                 <-  M�xima variabilidad del modelo
# SCE = Suma de Cuadrados del Error               <-  Suma de los residuales!!!
# SCR = Suma de Cuadrados de la Regresi�n         <-  Variabilidad del modelo
# SCT = sum( y_i - y_bar )^2
# SCE = sum( y_i - \hat{y_i} )^2
# SCR = sum( \hat{y_i} - y_bar )^2
# install.packages("imager")
plot( imager::load.image("suma de cuadrados.jpg") )

# Definimos entonces, la m�trica R2 de la siguiente manera.  R2 := SCR / SCT
# Partiendo de SCT = SCE + SCR, diviendo entre SCT tenemos que
# 1 = SCE/SCT + SCR/SCT = SCE/SCT - R^2.
# Es decir, podemos definir tambi�n R2 como R2 := 1 - SCE/SCT
# De tal manera que, mientras los residuales sean m�s peque�os, tendremos una R2 m�s cercana a 1.
SCT <- sum( (DATOS$Y - mean(DATOS$Y))^2 )
SCE <- sum( (DATOS$Y - MODELO$fitted.values)^2 )
SCR <- sum( (MODELO$fitted.values - mean(DATOS$Y))^2 )

# En caso de no tener intercepto, la descomposici�n de cuadrados es la siguiente
# SCT <- sum( (DATOS$Y - 0)^2 )
# SCE <- sum( (DATOS$Y - MODELO$fitted.values)^2 )
# SCR <- sum( (MODELO$fitted.values - 0)^2 )

# Podemos corroborar la igualdad n�mericamente realizando la siguiente operacion
# .Machine$double.eps es el �psilon de la m�quina!!
abs( SCT - ( SCE + SCR ) ) < .Machine$double.eps
R2     <- SCR / SCT
R2     <- 1 - SCE / SCT

# Para estimar el R2 ajustados, unicamente debemos dividir entre los grados de libertad
# de los errores, teniendo en cuenta que n = n�mero de observaciones
# p = n�mero de covariables (incluyendo beta0)
n <- nrow(DATOS)
p <- length(MODELO$coefficients)
R2_ADJ <- 1 - ( SCE/(n-p) ) / ( SCT/(n-1) )

# Se demuestra que los grados de libertad de la suma de cuadrados es la siguiente:
# SCT = n-1;  SCE = n-p;  SCR = p-1
# Ve�se que igualdad SCT = SCE + SCR tambi�n aplica para los grados de libertad

# En caso de que NO se tenga un intercepto (beta0)
# SCT = n-1;  SCE = n-k;  SCR = k
# Donde k es la cantidad de covariables, sin intercepto. Usualmente se denota que p = k+1


####################################################################################################
# Intervalo de confianza e intervalo de predicci�n
####################################################################################################

# INTERVALO_CONFIANZA y INTERVALO_PREDICCION contienen las estimaciones
# puntuales, as� como los l�mites inferiores y superiores
# Sin embargo, est�n en una matriz, por lo que las convertimos a DataFrames
plot(x = DATOS$X, y = DATOS$Y, main="Datos de Ajuste 1", col="#1CACDB", pch=19); grid()
INTERVALO_CONFIANZA  <- predict(object = MODELO, newdata = DATOS, interval = "confidence", level = 0.95)
INTERVALO_PREDICCION <- predict(object = MODELO, newdata = DATOS, interval = "prediction", level = 0.95)
INTERVALO_CONFIANZA  <- as.data.frame(INTERVALO_CONFIANZA)
INTERVALO_PREDICCION <- as.data.frame(INTERVALO_PREDICCION)

# Graficamos tanto la regresi�n, como su intervalo de confianza y el de predicci�n
lines(x = DATOS$X, MODELO$fitted.values,     col="forestgreen", lwd=2 )
lines(x = DATOS$X, INTERVALO_CONFIANZA$lwr,  col="orange", lwd=2 )
lines(x = DATOS$X, INTERVALO_CONFIANZA$upr,  col="orange", lwd=2 )
lines(x = DATOS$X, INTERVALO_PREDICCION$lwr, col="red", lwd=2 , lty=2 )
lines(x = DATOS$X, INTERVALO_PREDICCION$upr, col="red", lwd=2 , lty=2 )

# Si desean hacer los intervalos de manera algebraica, el siguiente enlace puede servir de ayuda
# https://rpubs.com/aaronsc32/regression-confidence-prediction-intervals
####################################################################################################
# Funciones �tiles
####################################################################################################
# Para obtener los coeficientes del modelo
coef(MODELO)
coefficients(MODELO)
# Resumen del modelo
summary( MODELO )
# Intervalo de Confianza
confint(MODELO)
# Intervalo de Predicci�n
predict(MODELO)
# Influencia de cada observaci�n (Leverage)
hatvalues(MODELO)
sum(hatvalues(MODELO))                        # Suma = Num. de predictores (variables) del modelo
hatvalues(MODELO) / mean(hatvalues(MODELO))   # Tasa de influencia con respecto a la media
# Regla Empirica para 'detectar' observaciones influyentes
hatvalues(MODELO)[ hatvalues(MODELO) / mean(hatvalues(MODELO)) >= 2 ]


####################################################################################################
# FIN DEL ARCHIVO
####################################################################################################