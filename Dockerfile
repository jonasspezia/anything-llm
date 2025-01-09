FROM ghcr.io/mintplex-labs/anything-llm:latest

WORKDIR /app

RUN npm install --save-dev prisma@6.2.1
RUN npm install @prisma/client@6.2.1

RUN npm install

RUN npx prisma migrate deploy

EXPOSE 3001

CMD ["npm", "start"]
