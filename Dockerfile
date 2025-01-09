FROM node:16-alpine

# Argumentos para UID e GID
ARG ARG_UID=1000
ARG ARG_GID=1000

# Criar grupo e usuário
RUN addgroup -g ${ARG_GID} appgroup && \
    adduser -D -G appgroup -u ${ARG_UID} appuser

WORKDIR /app

# Copiar arquivos de dependências
COPY package*.json ./

# Atualizar o Prisma para a versão 6.2.1
RUN npm install --save-dev prisma@6.2.1
RUN npm install @prisma/client@6.2.1

# Instalar dependências de produção
RUN npm install --production

# Copiar o restante do código
COPY . .

# Alterar proprietário dos arquivos para o usuário criado
RUN chown -R appuser:appgroup /app

# Rodar como o usuário não root
USER ${ARG_UID}:${ARG_GID}

# Aplicar migrações do Prisma
RUN npx prisma generate
RUN npx prisma migrate deploy

EXPOSE 3001

CMD ["npm", "start"]
