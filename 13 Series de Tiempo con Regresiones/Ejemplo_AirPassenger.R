install.packages("forecast") # Biblioteca para pronosticos (Forecast)
install.packages("tseries")  # Bibliotca de Series de Tiempo (Time Series)

# Funci�n que calcula mejores par�metros para un ARIMA
MODELO <- forecast::auto.arima(y = AirPassengers)
MODELO

# Realizamos el pron�stico y lo graficamos
PRONOSTICO <- forecast::forecast(object = MODELO)
plot( PRONOSTICO )