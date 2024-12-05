# Etapa 1: Construcción del proyecto
FROM eclipse-temurin:21-jdk AS buildstage

# Actualizar paquetes e instalar Maven
RUN apt-get update && apt-get install -y maven

# Configurar el directorio de trabajo
WORKDIR /app

# Copiar los archivos necesarios
COPY pom.xml .
COPY src /app/src
COPY Wallet_YQ95ND3X7BHK88DG /app/wallet

# Configurar la variable TNS_ADMIN para la Wallet de Oracle
ENV TNS_ADMIN=/app/wallet

# Construir el proyecto y generar el archivo .jar
RUN mvn clean package -DskipTests

# Etapa 2: Configuración de la imagen final
FROM eclipse-temurin:21-jdk

# Configurar el directorio de trabajo
WORKDIR /app

# Copiar el archivo .jar generado desde la etapa de construcción
COPY --from=buildstage /app/target/demo-0.0.1-SNAPSHOT.jar /app/app.jar

# Copiar la Wallet nuevamente
COPY Wallet_YQ95ND3X7BHK88DG /app/wallet

# Configurar la variable TNS_ADMIN para la Wallet en tiempo de ejecución
ENV TNS_ADMIN=/app/wallet

# Asegurarse de que el driver de Oracle esté incluido en el classpath
# (esto solo aplica si el driver no está en las dependencias de Maven)
# Agrega manualmente ojdbc8.jar si es necesario.
# COPY ojdbc8.jar /app/libs/ojdbc8.jar
ENV CLASSPATH=/app/libs/ojdbc8.jar:/app/app.jar

# Exponer el puerto 8080
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-cp", "/app/libs/ojdbc8.jar:/app/app.jar", "org.springframework.boot.loader.JarLauncher"]
