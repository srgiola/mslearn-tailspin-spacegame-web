# Usa la imagen oficial de .NET SDK como base
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Crea un usuario no root
RUN useradd -m azdo-user

# Instala las dependencias necesarias
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Instala Node.js versión 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Descarga e instala el agente de Azure DevOps
RUN mkdir /azdo && cd /azdo && \
    curl -O https://vstsagentpackage.azureedge.net/agent/3.241.0/vsts-agent-linux-x64-3.241.0.tar.gz && \
    tar zxvf vsts-agent-linux-x64-3.241.0.tar.gz

# Cambia la propiedad de los archivos al usuario no root
RUN chown -R azdo-user:azdo-user /azdo

# Cambia al usuario no root
USER azdo-user

# Configura el agente de Azure DevOps
WORKDIR /azdo
