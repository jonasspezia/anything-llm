FROM node:16-alpine

ARG ARG_UID=1000
ARG ARG_GID=1000

RUN addgroup -g ${ARG_GID} appgroup && \
    adduser -D -G appgroup -u ${ARG_UID} appuser

WORKDIR /app

COPY package*.json ./

# Atualizar o Prisma para a versão 6.2.1
RUN npm install --save-dev prisma@6.2.1
RUN npm install @prisma/client@6.2.1

RUN npm install --production

COPY . .

RUN chown -R appuser:appgroup /app

USER ${ARG_UID}:${ARG_GID}

# Copiar o script de entrada
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

EXPOSE 3001

CMD ["/app/docker-entrypoint.sh"]
